//
//  LoadRemoteImage.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

class LoadRemoteImage: AsyncOperation, LoadImage {
    
    let url: URL
    var result: Result<UIImage>?
    
    private let urlSession: URLSession
    private weak var task: URLSessionDataTask?
    private let cachePolicy: URLRequest.CachePolicy
    private let timeoutInterval: TimeInterval
    
    init?(url: URL,
          urlSession: URLSession = .shared,
          cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
          timeoutInterval: TimeInterval = 10) {
        
        guard !url.isFileURL else {
            return nil
        }
        
        self.url = url
        self.urlSession = urlSession
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        
    }
        
    override func main() {
                
        let urlRequest = URLRequest(url: url,
                                    cachePolicy: cachePolicy,
                                    timeoutInterval: timeoutInterval)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, respose, error) in
            
            guard let strongSelf = self else { return }
            
            defer {
                strongSelf.state = .finished
            }
            
            switch (error, data) {
            case (.none, .none):
                strongSelf.result = .failure(ImageLoadingError.noData)
                
            case (.some(let error), .none):
                strongSelf.result = .failure(error)
                
            case (_, .some(let data)):
                guard let image = UIImage(data: data) else {
                    strongSelf.result = .failure(ImageLoadingError.invalidData(data))
                    return
                }
                                
                strongSelf.result = .success(image)
            }
            
        }
        
        self.task = task
        
        task.resume()
        
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
}
