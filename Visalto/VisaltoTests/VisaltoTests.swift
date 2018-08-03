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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadImage() {
        
        let url = LocalTestImages.urls[0]
        
        Visalto.shared.loadImage(with: url) { result in
            
            switch result {
            case .success:
                break
            
            case .failure(let error):
                XCTFail("Test image wasn't loaded due to error: \(error.localizedDescription)")
            }
            
            XCTAssertNil(Visalto.shared.executingLoadImage(for: url), "Operation wasn't destroyed after completion")
        
        }
        
        XCTAssertNotNil(Visalto.shared.executingLoadImage(for: url), "Operation was destroyed before completion")
    }
    
}
