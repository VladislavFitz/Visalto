//
//  ImageCache.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

public final class ImageCache {
    
    /**
     In-Memory cache storage
    */
    private let storage: NSCache<NSURL, NSData>
    
    /**
     Object ensuring thread-safe access to cache
    */
    private let lock: NSObject
    
    /**
     Disk cache storage
    */
    var diskCache: DiskCache?
    
    var useDisk: Bool {
        
        get {
            return diskCache != nil
        }
        
        set {
            switch (diskCache, newValue) {
            case (.none, false), (.some, true):
                return
                
            case (.none, true):
                diskCache = try? DiskCache()
                
            case (.some(let diskCache), false):
                diskCache.clear()
                self.diskCache = .none
            }
        }
        
    }
    
    init(useDisk: Bool = true) {
        storage = NSCache()
        lock = NSObject()
        diskCache = useDisk ? try? DiskCache() : .none
    }
    
    func contains(_ key: URL) -> Bool {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        return storage.object(forKey: key as NSURL) != .none
        
    }
    
    func load(for key: URL) -> CacheAccessResult {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        if let inMemoryCachedData = storage.object(forKey: key as NSURL) {
            
            return .memoryHit(inMemoryCachedData as Data)
            
        } else if let diskCacheURL = diskCache?.fileURL(for: key) {
            
            return .diskHit(diskCacheURL)
            
        } else {
            
            return .miss
            
        }
        
    }
    
    func store(_ data: Data, forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        storage.setObject(data as NSData, forKey: key as NSURL)
        diskCache?.store(data, forKey: key)
        
    }
    
    func remove(for key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        storage.removeObject(forKey: key as NSURL)
        diskCache?.remove(forKey: key)
        
    }
    
    public func clear() {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        storage.removeAllObjects()
        diskCache?.clear()
        
    }
    
}

extension ImageCache {
    
    func store(_ image: UIImage, forKey key: URL) {
        
        guard let jpegRepresentation = UIImageJPEGRepresentation(image, 1) else { return }
        
        self.store(jpegRepresentation, forKey: key)
        
    }
    
}

extension ImageCache {
    
    enum CacheAccessResult {
        case memoryHit(Data)
        case diskHit(URL)
        case miss
    }
    
}
