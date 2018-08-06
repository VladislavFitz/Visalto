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
    
    let queue: OperationQueue
    public var urlSession: URLSession
    private let cache: ImageCache
    let executingOperations: ExecutingOperationsController
    
    public var qos: QualityOfService {
        
        get {
            return queue.qualityOfService
        }
        
        set {
            queue.qualityOfService = newValue
        }
        
    }
    
    public var useDiskCache: Bool {
        
        get {
            return cache.useDisk
        }
        
        set {
            cache.useDisk = newValue
        }
        
    }
    
    private init() {
        queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        urlSession = .shared
        cache = ImageCache(useDisk: true)
        executingOperations = ExecutingOperationsController()
    }
    
    /**
     Load image for web or file URL
     - parameter url: URL to image
     - parameter qos: Quality of service of load image operation. Default: .userInitiated
     - parameter queuePriority: Priority in queue of load image operation. Default: .normal
     - parameter completionQueue: Dispatch queue in which completion will be called
     - parameter completion: Callback returning result of load image operation
    */
    
    public func loadImage(with url: URL,
                   qos: QualityOfService = .userInitiated,
                   queuePriority: Operation.QueuePriority = .normal,
                   completionQueue: DispatchQueue = .main,
                   completion: @escaping (Result<UIImage>) -> Void) {
        
        /*
            If an operation with specified URL is alredy launched or waiting,
            no need to create one more operation with same URL
        */
        
        if let existingOperation = executingOperations.operation(for: url),
            existingOperation.operation.isReady || existingOperation.operation.isExecuting {
            return
        }
        
        let loadImage: LoadImage
        
        switch cache.load(for: url) {
        case .memoryHit(let imageData):
            loadImage = LoadImageFromData(url: url, data: imageData)
            
        case .diskHit(let fileURL):
            loadImage = LoadLocalImage(url: fileURL)!
            
        case .miss where url.isFileURL:
            loadImage = LoadLocalImage(url: url)!
            
        case .miss:
            loadImage = LoadRemoteImage(url: url, urlSession: urlSession)!
        }
        
        executingOperations.add(loadImage, for: url)
        
        loadImage.operation.qualityOfService = qos
        loadImage.operation.queuePriority = queuePriority
        
        loadImage.operation.completionBlock = { [weak self, weak loadImage] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.executingOperations.removeOperation(for: url)
            
            guard let result = loadImage?.result else {
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
    
    /**
     Cancel launched or scheduled operation
     - parameter url: URL to image
     */
    
    public func cancelLoading(for url: URL) {
        executingOperations.operation(for: url)?.cancel()
        executingOperations.removeOperation(for: url)
    }
    
    /**
     Cancel all launched and scheduled image loading operations
     */
    
    public func cancelAll() {
        queue.cancelAllOperations()
        executingOperations.clear()
    }
    
    /**
     Clear memory and disk caches
    */
    
    public func clearCache() {
        cache.clear()
    }
    
}
