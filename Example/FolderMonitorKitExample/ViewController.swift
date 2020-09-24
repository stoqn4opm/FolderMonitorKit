//
//  ViewController.swift
//  FolderMonitorKitExample
//
//  Created by Stoyan Stoyanov on 24/09/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import UIKit
import FolderMonitorKit


// MARK: - Class Definition

class ViewController: UIViewController {

    var tracker: FolderMonitor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let directory = URL.randomDirectory else { return }
        try! FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        
        tracker = try? FolderMonitor(url: directory, monitorQueue: .main) {
            print("changed!")
        }
        
        print("This demo is meant to be run in the simulator, so that you can open the tracked folder on your mac in Finder")
        
        do {
            try tracker?.start()
            print("has started tracking")
            print("Tracked directory: \(directory.path)")
            print("now go inside that directory and change its content!")
        } catch {
            print("can not started tracking, because: \(error)")
        }
    }
}

// MARK: - User Actions

extension ViewController {
    
    @IBAction private func stopTracking(_ sender: UIButton) {
        tracker?.stop()
    }
}

// MARK: - Helpers

extension URL {
    
    /// Creates url to a local directory in the caches directory with a random name.
    fileprivate static var randomDirectory: URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        var url = URL(fileURLWithPath: path, isDirectory: true)
        url.appendPathComponent("\(UUID().uuidString)")
        return url
    }
}
