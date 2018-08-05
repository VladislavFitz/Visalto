//
//  Visalto.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

public final class Visalto {
    
    public static let shared = Visalto()
    
    internal let queue: OperationQueue
    public let cache: ImageCache
    internal let executingOperations: ExecutingOperationsController
        
    private init() {
        queue = OperationQueue()
        queue.qualityOfService = .utility
        cache = ImageCache(useDisk: true)
        executingOperations = ExecutingOperationsController()
    }

    /**
     Load image for web or file URL
     - parameter url: URL to image
     - parameter qos: Quality of service of image loading
     - parameter completionQueue: Dispatch queue in which completion will be called
     - parameter completion: Callback returning result of load image operation
    */
    
    public func loadImage(with url: URL,
                   qos: QualityOfService = .userInitiated,
                   completionQueue: DispatchQueue = .main,
                   completion: @escaping (Result<UIImage>) -> Void) {
        
        /*
            If an operation with specified URL is alredy launched or waiting,
            no need to create one more operation
        */
        
        if let existingOperation = executingOperations.operation(for: url),
            existingOperation.operation.isReady || existingOperation.operation.isExecuting {
            return
        }
        
        let effectiveURL: URL
        
        switch cache.load(for: url) {
        case .memoryHit(let imageData):
            
            let imageFromData = ImageFromData(data: imageData)
            
            imageFromData.completionBlock = {
                completionQueue.async {
                    completion(imageFromData.result!)
                }
            }
            
            queue.addOperation(imageFromData)
            return
            
        case .diskHit(let fileURL):
            effectiveURL = fileURL
            
        case .miss:
            effectiveURL = url
        }
        
        let loadImage = LoadImageFactory.loadImage(for: effectiveURL)
        
        executingOperations.add(loadImage, for: url)
        
        loadImage.operation.qualityOfService = qos
        
        loadImage.operation.completionBlock = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.executingOperations.removeOperation(for: url)
            
            guard let result = loadImage.result else {
                return
            }
            
            if case .failure(let error) = result {
                print(error.localizedDescription)
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
    
    /**
     Cancel launched or scheduled operation
     - parameter url: URL to image
     */
    
    public func cancelLoading(for url: URL) {
        executingOperations.operation(for: url)?.cancel()
        executingOperations.removeOperation(for: url)
    }
    
    /**
     Cancels all launched and scheduled image loading operations
     */
    
    public func cancelAll() {
        queue.cancelAllOperations()
        executingOperations.clear()
    }
    
}
