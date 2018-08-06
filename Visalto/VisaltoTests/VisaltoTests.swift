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
        
        var loadedImagesURLs = Set<URL>()
        let urls = RemoteTestImages.urls

        for url in urls {
            
            Visalto.shared.loadImage(with: url) { result in
                loadedImagesURLs.insert(url)
                if loadedImagesURLs.count == urls.count {
                    exp.fulfill()
                }
            }
            
        }
        
        wait(for: [exp], timeout: 10)
        
    }
    
    func testCancellation() {
        
        let exp = expectation(description: "Load remote test images")
        
        let urls = RemoteTestImages.urls
        
        var loadedImagesURLs = Set<URL>()
        
        for url in urls {
            
            Visalto.shared.loadImage(with: url) { result in
                loadedImagesURLs.insert(url)
                if loadedImagesURLs.count == urls.count - 1 {
                    exp.fulfill()
                }
            }
            
            Visalto.shared.cancelLoading(for: urls[urls.endIndex - 2])
            
        }
        
        wait(for: [exp], timeout: 10)
        
        XCTAssertFalse(loadedImagesURLs.contains(urls[urls.endIndex - 2]))

    }
    
    func testLoadBigImage() {
        
        let url = URL(string: "https://images.pexels.com/photos/672143/pexels-photo-672143.jpeg")!

        measure {
            
            guard let loadImage = LoadRemoteImage(url: url) else { return }
            
            let queue = OperationQueue()
            
            queue.addOperation(loadImage)
            
            loadImage.waitUntilFinished()

        }
        
        
        
    }
    
}
