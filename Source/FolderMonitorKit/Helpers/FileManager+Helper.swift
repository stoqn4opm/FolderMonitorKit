//
//  FileManager+Helper.swift
//  FolderMonitorKit
//
//  Created by Stoyan Stoyanov on 28/09/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import Foundation


// MARK: - Disk Space Formatters

extension FileManager {
    
    /// Gives back the total disk space on this device as byte count formatted string.
    public var totalDiskSpace: String {
        ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: .file)
    }
    
    /// Gives back the free disk space on this device as byte count formatted string.
    public var freeDiskSpace: String {
        ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: .file)
    }
    
    /// Gives back the used disk space on this device as byte count formatted string.
    public var usedDiskSpace: String {
        ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: .file)
    }
}

// MARK: - Disk Space Calculation

extension FileManager {
    
    /// Gives back the amount of used disk space in bytes.
    public var usedDiskSpaceInBytes: Int64 { totalDiskSpaceInBytes - freeDiskSpaceInBytes }
    
    /// Calculates the free disk space in bytes.
    public var freeDiskSpaceInBytes: Int64 {
        do {
            let systemAttributes = try attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            let freeSpace = (systemAttributes[.systemFreeSize] as? NSNumber)?.int64Value
            return freeSpace ?? 0
        } catch {
            print("[FileManager] failed to get attributes of file system when calculating free disk space with error: \(error)")
            return 0
        }
    }
    
    /// Gives you back the total disk space in bytes.
    public var totalDiskSpaceInBytes: Int64 {
        do {
            let systemAttributes = try attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            let space = (systemAttributes[.systemSize] as? NSNumber)?.int64Value
            return space ?? 0
        } catch {
            print("[FileManager] failed to get attributes of file system when calculating total disk space with error: \(error)")
            return 0
        }
    }
}
