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
    
    private var loadImageByURL: [URL: LoadImage]
    
    private init() {
        queue = OperationQueue()
        queue.qualityOfService = .utility
        cache = ImageCache()
        loadImageByURL = [:]
    }
    
    public func executingLoadImage(for url: URL) -> LoadImage? {
        return loadImageByURL[url]
    }
    
    /**
     - returns: load image operation
     - parameter url: URL to image
     - parameter qos: Quality of service of image loading
     - parameter completionQueue: Dispatch queue in which completion will be called
     - parameter completion: Callback returning result of load image operation
    */
    
    public func loadImage(with url: URL,
                   qos: QualityOfService = .userInitiated,
                   completionQueue: DispatchQueue = .main,
                   completion: @escaping (Result<UIImage>) -> Void) -> LoadImage {
        
        let loadImage: LoadImage
        
        if url.isFileURL {
            loadImage = LoadLocalImage(url: url)!
        } else {
            loadImage = LoadRemoteImage(url: url)!
        }
        
        loadImage.operation.qualityOfService = qos
        
        loadImage.operation.completionBlock = { [weak self] in
            
            self?.loadImageByURL.removeValue(forKey: url)
            
            guard let result = loadImage.result else {
                return
            }
            
            completionQueue.async {
                completion(result)
            }
            
        }
        
        loadImageByURL[url] = loadImage
        
        queue.addOperation(loadImage.operation)
        
        return loadImage
        
    }
    
    public func cancelAll() {
        queue.cancelAllOperations()
    }
    
}
