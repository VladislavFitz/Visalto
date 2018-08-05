//
//  TestUrls.swift
//  TestVisaltoUI
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

extension String {
    
    var lines: [String] {
        var lines = [String]()
        enumerateLines { (line, _) in
            lines.append(line)
        }
        return lines
    }
    
}

enum TestImageURLs {
    
    static let urls: [URL] = {
        
        if
            let urlListFile = Bundle.main.url(forResource: "ImageURLs", withExtension: nil),
            let data = try? Data(contentsOf: urlListFile),
            let string = String(data: data, encoding: .utf8)
        {
            return string.lines.compactMap(URL.init)
        } else {
            return []
        }
        
    }()

}
