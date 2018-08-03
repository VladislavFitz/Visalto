//
//  LoadImage.swift
//  Visalto
//
//  Created by Vladislav Fitc on 03/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

protocol LoadImage {
    
    var url: URL { get }
    var result: Result<UIImage>? { get }
    var operation: Operation { get }
    
}

extension LoadImage {
    
    func cancel() {
        operation.cancel()
    }
    
}

extension LoadImage where Self: Operation {
    
    var operation: Operation {
        return self
    }
    
    
}
