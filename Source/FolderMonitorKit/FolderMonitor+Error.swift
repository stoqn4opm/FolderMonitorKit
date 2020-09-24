//
//  FolderMonitor+Error.swift
//  FolderMonitorKit
//
//  Created by Stoyan Stoyanov on 24/09/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - FolderMonitor Errors

extension FolderMonitor {
    
    /// All possible errors that can occur with `FolderMonitor`s.
    enum Error: Swift.Error {
        
        /// Occurs when trying to initialize `FolderMonitor` with invalid url.
        case invalidURL(String)
        
        /// Occurs when `FolderMonitor` is given a URL to a non existing location in the file system.
        case directoryDoesNotExist(String)
    }
}
