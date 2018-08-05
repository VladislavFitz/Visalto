//
//  AsyncOperation.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

open class AsyncOperation: Operation {
    
    public var state = State.ready {
        
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
        
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    override open var isFinished: Bool {
        return state == .finished
    }
    
    override open func start() {
        
        if isCancelled {
            state = .finished
            return
        }
        
        main()
        state = .executing
        
    }
    
    override open func cancel() {
        super.cancel()
        state = .finished
    }
    
}

extension AsyncOperation {
    
    public enum State: String {
        
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
        
    }
    
}
