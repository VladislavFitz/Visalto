//
//  ImageCacheTests.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

import XCTest
@testable import Visalto

class ImageCacheTests: XCTestCase {
    
    func testLoadStore() {
        
        let cache = ImageCache(useDisk: false)

        cache.store(LocalTestImages.image(atIndex: 1)!, forKey: LocalTestImages.urls[1])
        
        let expectedKey = LocalTestImages.urls[1]
        let unexpectedKey = LocalTestImages.urls[0]
        
        guard case .memoryHit = cache.load(for: expectedKey) else {
            XCTFail("Image ET1 must be in the cache")
            return
        }
        
        guard case .miss = cache.load(for: unexpectedKey) else {
            XCTFail("Image ET0 must not be in the cache")
            return
        }
        
    }
    
    func testContains() {
        
        let cache = ImageCache()

        cache.store(LocalTestImages.image(atIndex: 1)!, forKey: LocalTestImages.urls[1])
        
        let expectedKey = LocalTestImages.urls[1]
        let unexpectedKey = LocalTestImages.urls[0]
        
        XCTAssertTrue(cache.contains(expectedKey), "Image ET1 must be in the cache")
        XCTAssertFalse(cache.contains(unexpectedKey), "Image ET0 must not be in the cache")
        
    }
    
    func testRemove() {
        
        let cache = ImageCache()
        
        cache.store(LocalTestImages.image(atIndex: 0)!, forKey: LocalTestImages.urls[0])
        cache.store(LocalTestImages.image(atIndex: 1)!, forKey: LocalTestImages.urls[1])

        cache.remove(for: LocalTestImages.urls[0])
        
        let expectedKey = LocalTestImages.urls[1]
        let unexpectedKey = LocalTestImages.urls[0]
        
        XCTAssertTrue(cache.contains(expectedKey), "Image ET1 must be in the cache")
        XCTAssertFalse(cache.contains(unexpectedKey), "Image ET0 must not be in the cache")
        
    }
    
}
