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
    
    let cache = ImageCache()
    
    override func setUp() {
        cache.store(LocalTestImages.image(atIndex: 0)!, forKey: LocalTestImages.urls[0])
    }
    
    override func tearDown() {
        cache.clear()
    }
    
    func testLoad() {
        
        XCTAssertNotNil(cache.load(for: LocalTestImages.urls[0]), "Image ET0 wasn't loaded")
        XCTAssertNil(cache.load(for: LocalTestImages.urls[1]), "Image ET1 isn't in the cache")
                
    }
    
    func testStore() {
        
        cache.store(LocalTestImages.image(atIndex: 1)!, forKey: LocalTestImages.urls[1])
        
        XCTAssertNotNil(cache.load(for: LocalTestImages.urls[0]), "Image ET0 isn't in the cache")
        XCTAssertNotNil(cache.load(for: LocalTestImages.urls[1]), "Image ET0 isn't in the cache")

    }
    
    func testRemove() {
        
        cache.remove(for: LocalTestImages.urls[0])
        
        XCTAssertNil(cache.load(for: LocalTestImages.urls[0]), "Image ET0 mustn't be in cache")
        
    }
    
}
