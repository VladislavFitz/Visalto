//
//  ImageCache.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

final class ImageCache {
    
    private let storage: NSCache<NSURL, UIImage>
    private let lock: NSObject
    
    init() {
        storage = NSCache()
        lock = NSObject()
    }
    
    func contains(_ key: URL) -> Bool {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        return storage.object(forKey: key as NSURL) != nil
    }
    
    func load(for key: URL) -> UIImage? {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        return storage.object(forKey: key as NSURL)
    }
    
    func store(_ image: UIImage, forKey key: URL) {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        storage.setObject(image, forKey: key as NSURL)
    }
    
    func remove(for key: URL) {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        storage.removeObject(forKey: key as NSURL)
    }
    
    func clear() {
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        storage.removeAllObjects()
    }
    
}
