//
//  LoadImageFromData.swift
//  Visalto
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

class LoadImageFromData: Operation, LoadImage {
    
    let url: URL
    var result: Result<UIImage>?
    private let data: Data
    
    init(url: URL, data: Data) {
        self.url = url
        self.data = data
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        if let image = UIImage(data: data) {
            result = .success(image)
        } else {
            result = .failure(ImageLoadingError.invalidData(data))
        }
        
    }
    
}
