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
    
}
