//
//  ImageFromData.swift
//  Visalto
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

class ImageFromData: Operation {
    
    let data: Data
    var result: Result<UIImage>?
    
    init(data: Data) {
        self.data = data
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        if let image = UIImage(data: data) {
            result = .success(image)
        } else {
            result = .failure(Error.incorrectData)
        }
        
    }
    
}

extension ImageFromData {
    
    enum Error: Swift.Error {
        case incorrectData
    }
    
}
