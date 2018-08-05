//
//  VisaltoTests.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import XCTest
@testable import Visalto

class VisaltoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadMutlipleImages() {
        
        
    }
    
    func testLoadImage() {
        
        let exp = expectation(description: "Load eiffel tower image from web")
        
        let url = LocalTestImages.urls[1]
        
        Visalto.shared.loadImage(with: url) { result in
            
            switch result {
            case .success:
                break
            
            case .failure(let error):
                XCTFail("Test image wasn't loaded due to error: \(error.localizedDescription)")
            }
            
            XCTAssertNil(Visalto.shared.executingOperations.operation(for: url), "Operation wasn't destroyed after completion")
            exp.fulfill()
        }
        
        XCTAssertNotNil(Visalto.shared.executingOperations.operation(for: url), "Operation was destroyed before completion")
        
        wait(for: [exp], timeout: 3)
    }
    
    func testMultipleImagesLoading() {
        
        let exp = expectation(description: "Load all remote test images")
        
        var loadedURLs = Set(RemoteTestImages.urls)
        
        for (index, url) in RemoteTestImages.urls.enumerated() {
            
            debugPrint("Start loading image \(index)")
            
            Visalto.shared.loadImage(with: url) { result in
                debugPrint("Finish loading image for \(index)")
                loadedURLs.remove(url)
                if loadedURLs.isEmpty {
                    exp.fulfill()
                }
            }
            
        }
        
        wait(for: [exp], timeout: 10)
        
    }

        
}
