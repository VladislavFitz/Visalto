//
//  LoadLocalImage.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

class LoadLocalImage: Operation, LoadImage {
    
    let url: URL
    var result: Result<UIImage>?
    
    init?(url: URL) {
        
        guard url.isFileURL else {
            return nil
        }
        
        self.url = url
        
    }
    
    deinit {
        
    }
    
    override func main() {
        
        do {
            
            if isCancelled {
                return
            }
            
            let data = try Data(contentsOf: url)
            
            if isCancelled {
                return
            }
            
            guard let image = UIImage(data: data) else {
                result = .failure(ImageLoadingError.invalidData(data))
                return
            }
            
            result = .success(image)
            
        } catch let error {
            result = .failure(error)
        }
        
    }
    
}
