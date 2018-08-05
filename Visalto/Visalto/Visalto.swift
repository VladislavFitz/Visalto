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
    internal let executingOperations: ExecutingOperationsController
        
    private init() {
        queue = OperationQueue()
        queue.qualityOfService = .utility
        cache = ImageCache()
        executingOperations = ExecutingOperationsController()
    }

    /**
     - parameter url: URL to image
     - parameter qos: Quality of service of image loading
     - parameter completionQueue: Dispatch queue in which completion will be called
     - parameter completion: Callback returning result of load image operation
    */
    
    public func loadImage(with url: URL,
                   qos: QualityOfService = .userInitiated,
                   completionQueue: DispatchQueue = .main,
                   completion: @escaping (Result<UIImage>) -> Void) {
        
        if let existingOperation = executingOperations.operation(for: url),
            existingOperation.operation.isReady || existingOperation.operation.isExecuting {
            return
        }
        
        if let cachedImage = cache.load(for: url) {
            
            completionQueue.async {
                completion(.success(cachedImage))
            }
            
        }
        
        let loadImage = LoadImageFactory.loadImage(for: url)
        
        executingOperations.add(loadImage)
        
        loadImage.operation.qualityOfService = qos
        
        loadImage.operation.completionBlock = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.executingOperations.removeOperation(for: url)
            
            guard let result = loadImage.result else {
                return
            }
            
            if case .success(let image) = result {
                strongSelf.cache.store(image, forKey: url)
            }
            
            completionQueue.async {
                completion(result)
            }
            
        }

        queue.addOperation(loadImage.operation)
        
    }
    
    public func cancelAll() {
        queue.cancelAllOperations()
    }
    
}
