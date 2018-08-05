//
//  ImageCache.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

public final class ImageCache {
    
    private let storage: NSCache<NSURL, NSData>
    private let lock: NSObject
    private let diskCache: DiskCache?
    
    init(useDisk: Bool = true) {
        storage = NSCache()
        lock = NSObject()
        storage.countLimit = 5
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
    
    func store(_ image: UIImage, forKey key: URL) {
        
        guard let jpegRepresentation = UIImageJPEGRepresentation(image, 1) else { return }
        
        self.store(jpegRepresentation, forKey: key)
        
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
    
    enum CacheAccessResult {
        case memoryHit(Data)
        case diskHit(URL)
        case miss
    }
    
}
