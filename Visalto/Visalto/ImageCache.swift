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
    
    init() {
        storage = NSCache()
    }
    
    func load(for key: URL) -> UIImage? {
        return storage.object(forKey: key as NSURL)
    }
    
    func store(_ image: UIImage, forKey key: URL) {
        storage.setObject(image, forKey: key as NSURL)
    }
    
    func contains(_ key: URL) -> Bool {
        return storage.object(forKey: key as NSURL) != nil
    }
    
    func remove(for key: URL) {
        storage.removeObject(forKey: key as NSURL)
    }
    
    func clear() {
        storage.removeAllObjects()
    }
    
}
