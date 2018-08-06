//
//  String+Lines.swift
//  Visalto
//
//  Created by Vladislav Fitc on 06/08/2018.
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
