//
//  FolderMonitor+Delegate.swift
//  FolderMonitorKit
//
//  Created by Stoyan Stoyanov on 24/09/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - FolderMonitor Delegate

/// Set of requirements that every delegate of `FolderMonitor` must conform to.
public protocol FolderMonitorDelegate: AnyObject {
    
    /// Invoked when monitoring is started
    ///
    /// - Parameter monitor: The folder monitor that has just started.
    func folderMonitorDidStart(_ monitor: FolderMonitor)
    
    /// Invoked when monitoring is stopped.
    ///
    /// - Parameter monitor: The folder monitor that has just stopped.
    func folderMonitorDidStop(_ monitor: FolderMonitor)
    
    /// Invoked when a change is observed in the tracked directory.
    ///
    /// - Parameter monitor: The monitor that observed the change.
    func folderMonitorDidReceiveChange(_ monitor: FolderMonitor)
}
