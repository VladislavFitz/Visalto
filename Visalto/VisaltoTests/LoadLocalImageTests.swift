//
//  LoadLocalImageTests.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import XCTest
@testable import Visalto

class LoadLocalImageTests: XCTestCase {
    
    func testImageLoading() {
        
        let exp = expectation(description: "Load eiffel tower image from disk")
        
        let url = Bundle.testBundle.url(forResource: "ET0", withExtension: "jpeg")!
        
        let loadImage = LoadLocalImage(url: url)!
        
        loadImage.qualityOfService = .default
        
        loadImage.completionBlock = {
            exp.fulfill()
        }
        
        OperationQueue.main.addOperation(loadImage)
        
        wait(for: [exp], timeout: 3)
        
    }
    
}
