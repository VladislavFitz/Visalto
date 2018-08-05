//
//  ExecutingOperationsController.swift
//  Visalto
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

internal class ExecutingOperationsController {
    
    private var operationsByURL: [URL: LoadImage]
    private let lock: NSObject

    init() {
        operationsByURL = [:]
        lock = NSObject()
    }
    
    internal func operation(for url: URL) -> LoadImage? {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }

        return operationsByURL[url]
    }
    
    internal func add(_ loadImage: LoadImage) {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }

        operationsByURL[loadImage.url] = loadImage
    }
    
    internal func removeOperation(for url: URL) {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }

        operationsByURL.removeValue(forKey: url)
    }
    
}
