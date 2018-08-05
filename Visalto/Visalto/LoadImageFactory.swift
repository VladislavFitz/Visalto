//
//  LoadImageFactory.swift
//  Visalto
//
//  Created by Vladislav Fitc on 03/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

class LoadImageFactory {
    
    static func loadImage(for url: URL) -> LoadImage {
        
        let loadImage: LoadImage
        
        if url.isFileURL {
            loadImage = LoadLocalImage(url: url)!
        } else {
            loadImage = LoadRemoteImage(url: url)!
        }
        
        return loadImage

    }
    
}
