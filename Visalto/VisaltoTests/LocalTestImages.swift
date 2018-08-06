//
//  TestImages.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation
@testable import Visalto

struct LocalTestImages {
    
    private static let imagePrefix = "ET"
    private static let lastImageIndex = 4
    
    static let urls = (0...lastImageIndex)
        .map { "\(imagePrefix)\($0)" }
        .compactMap { Bundle.testBundle.url(forResource: $0, withExtension: "jpg") }
    
    static func image(atIndex index: Int) -> UIImage? {
        guard 0...lastImageIndex ~= index else { return nil }
        return image(for: urls[index])
    }
    
    static func image(for url: URL) -> UIImage? {
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        return image
        
    }
    
}
