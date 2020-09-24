//
//  FolderMonitor.swift
//  FolderMonitorKit
//
//  Created by Stoyan Stoyanov on 24/09/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Default Monitoring Queue

extension DispatchQueue {
    
    /// Creates a new folderMonitor queue for a `FolderMonitor` from `FolderMonitorKit`.
    public static var newMonitorQueue: DispatchQueue { DispatchQueue(label: "FolderMonitorKit-Queue", attributes: .concurrent) }
}

// MARK: - Class Definition

/// Simple class, that is able to keep track of local directory,
/// and invoke a callback when a change in the directory happens.
public final class FolderMonitor {
    
    /// The URL of the directory that is being monitored.
    public let url: URL
    
    /// A dispatch queue used for sending file changes in the directory.
    public let monitorQueue: DispatchQueue
    
    /// The file system event that is tracked by this `FolderMonitor`.
    public let trackingEvent: DispatchSource.FileSystemEvent
    
    /// Optional delegate that will get notified regarding events with this `FolderMonitor`.
    public weak var delegate: FolderMonitorDelegate?
    
    
    /// Callback that gets invoked when a change occurs.
    private let onChange: (() -> ())?
    
    /// A file descriptor for the monitored directory.
    private var monitoredFolderFileDescriptor: CInt = -1
    
    /// A dispatch source to monitor a file descriptor created from the directory.
    private var dispatchSource: DispatchSourceFileSystemObject?

    
    /// Creates a new folder monitor for a given url.
    ///
    /// You can also listen for posted notifications from this `FolderMonitor` in the `NotificationCenter.default`.
    /// The posted notifications are:
    ///  - `.folderMonitoringStarted` - Posted when a `FolderMonitor` starts monitoring. The object of the notification is the monitor that just started.
    ///  - `folderMonitoringStopped` - Posted when a `FolderMonitor` stops monitoring. The object of the notification is the monitor that just stopped.
    ///  - `.folderMonitorObservedChange` - Posted when a `FolderMonitor` observes a change in the folder that is monitoring. The object of the notification is the monitor that just observed a change.
    ///
    /// - Parameters:
    ///   - url: The directory you want monitored.
    ///   - trackingEvent: The file system event that is tracked by this `FolderMonitor`. Default is: `.write`.
    ///   - monitorQueue: The dispatch queue on which to receive updates. Default is: `DispatchQueue.monitorQueue`
    ///   - delegate: Optional delegate, that will get notified when changes occurs.
    ///   - onChange: Optional closure, that will get invoked when changes occurs.
    /// - Throws: In case there is an issue with the url like for example it points to non existing thing.
    public init(url: URL, trackingEvent: DispatchSource.FileSystemEvent = .write, monitorQueue: DispatchQueue = .newMonitorQueue, delegate: FolderMonitorDelegate? = nil, onChange: (() -> ())? = nil) throws {
        guard url.isFileURL else { throw Error.invalidURL("[FolderMonitor] the given url for monitoring: \(url) is not a file: url. `FolderMonitor` only works with local files stored in the file system.") }
        
        guard FileManager.default.fileExists(atPath: url.path) else { throw Error.directoryDoesNotExist("[FolderMonitor] the given path: \(url.path) does not exist on the file system.") }
        self.url = url
        self.delegate = delegate
        self.onChange = onChange
        self.monitorQueue = monitorQueue
        self.trackingEvent = trackingEvent
    }
    
    deinit {
        stop()
    }
}

// MARK: - Monitoring

extension FolderMonitor {
    
    /// Starts listening for changes to the directory (if we are not already).
    /// Don't forget to call `stop()` when you are done monitoring.
    ///
    /// - Throws: Will throw if the directory that we are trying to monitor dissapeared.
    public func start() throws {
        
        guard FileManager.default.fileExists(atPath: url.path) else { throw Error.directoryDoesNotExist("[FolderMonitor] the given path: \(url.path) does not exist on the file system.") }
        guard dispatchSource == nil && monitoredFolderFileDescriptor == -1 else { return }
        
        // Open the directory referenced by URL for monitoring only.
        monitoredFolderFileDescriptor = open(url.path, O_EVTONLY)
        
        // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
        dispatchSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: monitoredFolderFileDescriptor, eventMask: trackingEvent, queue: monitorQueue)
        
        // Define the block to call when a file change is detected.
        dispatchSource?.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.onChange?()
            self.delegate?.folderMonitorDidReceiveChange(self)
            NotificationCenter.default.post(name: .folderMonitorObservedChange, object: self)
        }
        
        // Define a cancel handler to ensure the directory is closed when the source is cancelled.
        dispatchSource?.setCancelHandler { [weak self] in
            guard let self = self else { return }
            close(self.monitoredFolderFileDescriptor)
            self.monitoredFolderFileDescriptor = -1
            self.dispatchSource = nil
            self.delegate?.folderMonitorDidStop(self)
            NotificationCenter.default.post(name: .folderMonitoringStopped, object: self)
        }
        
        // Start monitoring the directory via the source.
        dispatchSource?.resume()
        delegate?.folderMonitorDidStart(self)
        NotificationCenter.default.post(name: .folderMonitoringStarted, object: self)
    }
    
    /// Stop listening for changes to the directory, if `start()` was invoked first.
    public func stop() {
        dispatchSource?.cancel()
    }
}
