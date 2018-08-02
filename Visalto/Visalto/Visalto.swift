//
//  Visalto.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

final class Visalto {
    
    static let shared = Visalto()
    
    internal let queue: OperationQueue
    internal let cache: ImageCache
    
    private init() {
        queue = OperationQueue()
        queue.qualityOfService = .utility
        cache = ImageCache()
    }
    
    func loadImage(with url: URL, qos: QualityOfService = .userInitiated, completionQueue: DispatchQueue = .main, completion: @escaping (Result<UIImage>) -> Void) {
        
        let operation: LoadImage
        
        if url.isFileURL {
            operation = LoadLocalImage(url: url)!
        } else {
            operation = LoadRemoteImage(url: url)!
        }
        
        operation.qualityOfService = .userInteractive
        
        operation.completionBlock = {
            
            guard let result = operation.result else {
                return
            }
            
            completionQueue.async {
                completion(result)
            }
            
        }
        
        queue.addOperation(operation)

        
    }
    
}
