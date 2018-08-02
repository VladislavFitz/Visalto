//
//  LoadRemoteImageTests.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import XCTest
@testable import Visalto

class LoadRemoteImageTests: XCTestCase {
    
    func testImageLoading() {
        
        let exp = expectation(description: "Load eiffel tower image from web")
        
        let url = URL(string: "https://www.toureiffel.paris/themes/custom/tour_eiffel/img/poster-tour-eiffel-jour-nuit.jpg")!
        
        let loadImage = LoadRemoteImage(url: url)!
        
        loadImage.qualityOfService = .default
        
        loadImage.completionBlock = {
            exp.fulfill()
        }
        
        OperationQueue.main.addOperation(loadImage)
        
        wait(for: [exp], timeout: 3)
        
    }
    
}
