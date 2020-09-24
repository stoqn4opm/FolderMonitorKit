//
//  FolderMonitor+Notifications.swift
//  FolderMonitorKit
//
//  Created by Stoyan Stoyanov on 24/09/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Notifications

extension Notification.Name {
    
    /// Posted when a `FolderMonitor` starts monitoring. The object of the notification is the monitor that just started.
    public static let folderMonitoringStarted = Notification.Name("FolderMonitorKit.FolderMonitorDidStart")
    
    /// Posted when a `FolderMonitor` stops monitoring. The object of the notification is the monitor that just stopped.
    public static let folderMonitoringStopped = Notification.Name("FolderMonitorKit.FolderMonitorDidStopped")
    
    /// Posted when a `FolderMonitor` observes a change in the folder that is monitoring. The object of the notification is the monitor that just observed a change.
    public static let folderMonitorObservedChange = Notification.Name("FolderMonitorKit.FolderMonitorObservedChange")
}
