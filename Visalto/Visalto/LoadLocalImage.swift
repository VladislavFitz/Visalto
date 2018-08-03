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
    
    override func main() {
        
        if let cachedImage = Visalto.shared.cache.load(for: url) {
            result = .success(cachedImage)
        }
        
        do {
            
            let data = try Data(contentsOf: url)
            
            if isCancelled {
                return
            }
            
            guard let image = UIImage(data: data) else {
                result = .failure(ImageLoadingError.invalidData(data))
                return
            }
            
            Visalto.shared.cache.store(image, forKey: url)
            result = .success(image)
            
        } catch let error {
            result = .failure(error)
        }
        
    }
    
}
