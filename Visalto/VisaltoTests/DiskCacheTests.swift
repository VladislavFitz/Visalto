//
//  DiskCacheTests.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import XCTest
@testable import Visalto

class DiskCacheTests: XCTestCase {
    
    func testLoadStore() {
        
        let cache = try! DiskCache()
        let key = URL(string: "com.visalto.testKey")!
        let image = LocalTestImages.image(atIndex: 0)!
        let data = UIImageJPEGRepresentation(image, 1)!
        
        cache.store(data, forKey: key)
        
        XCTAssertFalse(cache.isEmpty)
        
        guard let loadedDataURL = cache.fileURL(for: key) else {
            XCTFail("URL for stored data not found")
            return
        }
        
        guard let loadedData = try? Data(contentsOf: loadedDataURL) else {
            XCTFail("Cannot load cached data")
            return
        }
        
        XCTAssertEqual(data, loadedData)
        
    }
    
    func testRemove() {
        
        let cache = try! DiskCache()
        let key = URL(string: "com.visalto.testKey")!
        let image = LocalTestImages.image(atIndex: 0)!
        let data = UIImageJPEGRepresentation(image, 1)!
        
        cache.store(data, forKey: key)
        cache.remove(forKey: key)
        
        XCTAssertTrue(cache.isEmpty)
        XCTAssertNil(cache.fileURL(for: key))
        
    }
    
    func testContains() {
        
        let cache = try! DiskCache()
        let key = URL(string: "com.visalto.testKey")!
        let image = LocalTestImages.image(atIndex: 0)!
        let data = UIImageJPEGRepresentation(image, 1)!

        cache.store(data, forKey: key)
        
        XCTAssertTrue(cache.contains(key))
        
        
    }
    
    func testMapping() {
        
        let cache = try! DiskCache()
        let key = URL(string: "com.visalto.testKey")!
        let image = LocalTestImages.image(atIndex: 0)!
        let data = UIImageJPEGRepresentation(image, 1)!

        cache.store(data, forKey: key)
        
        guard let fileURL = cache.fileURL(for: key) else {
            XCTFail("URL for stored data not found")
            return
        }
        
        XCTAssertEqual(fileURL.pathComponents.last, "visaltoCachedImage0")
        
    }
    
    func testClear() {
        
        let cache = try! DiskCache()
        
        let testDataSet: [(URL, Data)] = (0..<LocalTestImages.urls.count).map {
            let data = UIImageJPEGRepresentation(LocalTestImages.image(atIndex:$0)!, 1)!
            let key = URL(string: "com.visalto.testKey.\($0)")!
            return (key, data)
        }
        
        testDataSet.forEach { (key, data) in
            cache.store(data, forKey: key)
        }
        
        cache.clear()
        
        XCTAssertTrue(cache.isEmpty)
        
    }
    
}
