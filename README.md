# FolderMonitorKit
![](https://img.shields.io/badge/version-1.0-brightgreen.svg)


FolderMonitorKit is iOS Dynamic Framework allowing you to observe changes in the file system. This started by following [this article](https://medium.com/over-engineering/monitoring-a-folder-for-changes-in-ios-dc3f8614f902), so shout out to [Daniel Galasko](https://medium.com/@danielgalasko?source=post_page-----dc3f8614f902--------------------------------) for the nice tutorial that he wrote. But then i polished it a bit further by making it configurable and able to "talk back" in different ways to you.

Build using Swift 5.3, Xcode 11.7, supports iOS 10.0+

# Usage

- From code:
	1. Make an instance of `FolderMonitor` by giving it at least the target URL.
	2. Hold the instance in memory so that its not deallocated while you are using it.
	3. Call start() to start observing the directory for changes.
	4. Call stop() to stop observing.

`FolderMonitor` interface looks like:

```swift
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
    public init(url: URL, trackingEvent: DispatchSource.FileSystemEvent = .write, monitorQueue: DispatchQueue = .newMonitorQueue, delegate: FolderMonitorDelegate? = nil, onChange: (() -> ())? = nil) throws
}

// MARK: - Monitoring

extension FolderMonitor {

    /// Starts listening for changes to the directory (if we are not already).
    /// Don't forget to call `stop()` when you are done monitoring.
    ///
    /// - Throws: Will throw if the directory that we are trying to monitor dissapeared.
    public func start() throws

    /// Stop listening for changes to the directory, if `start()` was invoked first.
    public func stop()
}
``` 

You can also listen to `FolderMonitor` events from the `NotificationCenter.default` by subsribing to the following notifications:

```swift
// MARK: - Notifications

extension NSNotification.Name {

    /// Posted when a `FolderMonitor` starts monitoring. The object of the notification is the monitor that just started.
    public static let folderMonitoringStarted: Notification.Name

    /// Posted when a `FolderMonitor` stops monitoring. The object of the notification is the monitor that just stopped.
    public static let folderMonitoringStopped: Notification.Name

    /// Posted when a `FolderMonitor` observes a change in the folder that is monitoring. The object of the notification is the monitor that just observed a change.
    public static let folderMonitorObservedChange: Notification.Name
}
```

In addition to monitoring changes in directories, the dynamic framework also contains userful extensions for `FileManager` class from `Foundation` giving you the ability to check easily the disk usage.

```swift

// MARK: - Disk Space Formatters

extension FileManager {

    /// Gives back the total disk space on this device as byte count formatted string.
    public var totalDiskSpace: String { get }

    /// Gives back the free disk space on this device as byte count formatted string.
    public var freeDiskSpace: String { get }

    /// Gives back the used disk space on this device as byte count formatted string.
    public var usedDiskSpace: String { get }
}

// MARK: - Disk Space Calculation

extension FileManager {

    /// Gives back the amount of used disk space in bytes.
    public var usedDiskSpaceInBytes: Int64 { get }

    /// Calculates the free disk space in bytes.
    public var freeDiskSpaceInBytes: Int64 { get }

    /// Gives you back the total disk space in bytes.
    public var totalDiskSpaceInBytes: Int64 { get }
}
```

# Installation

### Swift Package Manager
1. Navigate to `XCode project` > `ProjectName` > `Swift Packages` > `+ (add)`
2. Paste the url `https://github.com/stoqn4opm/FolderMonitorKit.git`
3. Select the needed targets.

### Carthage Installation

1. In your `Cartfile` add `github "stoqn4opm/FolderMonitorKit"`
2. Link the build framework with the target in your XCode project

For detailed instructions check the official Carthage guides [here](https://github.com/Carthage/Carthage)

### Manual Installation

1. Download the project and build the shared target called `FolderMonitorKit`
2. Add the product in the list of "embed frameworks" list inside your project's target or create a work space with FolderMonitorKit and your project and link directly the product of FolderMonitorKit's target to your target "embed frameworks" list

# License
Licensed under MIT. For more information, see `LICENSE`
