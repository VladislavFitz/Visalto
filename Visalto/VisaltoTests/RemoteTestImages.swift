//
//  RemoteTestImages.swift
//  VisaltoTests
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

struct RemoteTestImages {
    
    static let urls: [URL] = {
        
        if
            let urlListFile = Bundle.testBundle.url(forResource: "ImageURLs", withExtension: nil),
            let data = try? Data(contentsOf: urlListFile),
            let string = String(data: data, encoding: .utf8)
        {
            return string.lines.compactMap(URL.init)
        } else {
            return []
        }
        
    }()
    
}
