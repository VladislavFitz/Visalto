//
//  DiskCache.swift
//  Visalto
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

/**
 Simple disk cache using web URL as cache key.
 Stores dictionary which maps web URL to file ID on disk.
 State of dictionary is stored in UserDefaults.
 */

final class DiskCache {
    
    /**
     Dictionary mapping web URL to file ID
    */
    private var urlToFileMap: [URL: String]
    
    /**
     Variable used for generation of a unique file ID for newly stored files
    */
    private var fileCounter: Int
    
    /**
     Object ensuring thread-safe access to cache
    */
    private let lock: NSObject
    
    private let cacheFolderURL: URL
    private let fileManager: FileManager
    
    private let folderPath = "visaltoCache"
    private let filePrefix = "visaltoCachedImage"
    private let storedStateKey = "visalto.diskCache.state"
    
    var isEmpty: Bool {
        return urlToFileMap.isEmpty
    }
    
    init(fileManager: FileManager = .default) throws {
        
        self.urlToFileMap = [:]
        self.lock = NSObject()
        self.fileManager = fileManager
        self.fileCounter = 0
        
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw Error.userDocumentDirectoryNotFound
        }
        
        cacheFolderURL = documentsURL.appendingPathComponent(folderPath)
        
        restoreState()
        
        if !fileManager.fileExists(atPath: cacheFolderURL.path) {
            try fileManager.createDirectory(atPath: cacheFolderURL.path, withIntermediateDirectories: true, attributes: .none)
        }
        
    }
    
    func fileURL(for url: URL) -> URL? {
        
        if url.isFileURL {
            return url
        }
        
        guard let fileID = urlToFileMap[url] else {
            return .none
        }
        
        return fileURL(forFileWithID: fileID)
        
    }
    
    private func fileID() -> String {
        let fileID = "\(filePrefix)\(fileCounter)"
        fileCounter += 1
        return fileID
    }
    
    private func fileURL(forFileWithID fileID: String) -> URL {
        return cacheFolderURL.appendingPathComponent(fileID)
    }
    
    func contains(_ key: URL) -> Bool {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        return urlToFileMap[key] != nil
        
    }
    
    func store(_ data: Data, forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        if key.isFileURL || urlToFileMap[key] != nil {
            return
        }
        
        let fileID = self.fileID()
        let fileURL = self.fileURL(forFileWithID: fileID)
        
        fileManager.createFile(atPath: fileURL.path, contents: data, attributes: .none)

        urlToFileMap[key] = fileID
        
        storeState()
        
    }
    
    func remove(forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        guard let fileID = urlToFileMap[key] else {
            return
        }
        
        let fileURL = self.fileURL(forFileWithID: fileID)
        
        urlToFileMap.removeValue(forKey: key)
        try? fileManager.removeItem(at: fileURL)
        
        storeState()
        
    }
    
    func clear() {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        urlToFileMap.removeAll()
        fileCounter = 0
        
        for fileID in urlToFileMap.values {
            let fileURL = self.fileURL(forFileWithID: fileID)
            try? fileManager.removeItem(at: fileURL)
        }
        
        storeState()
        
    }
    
    private func storeState() {
        
        let state = State(fileCounter: fileCounter, urlMap: urlToFileMap)
        if let encodedState = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encodedState, forKey: storedStateKey)
        }
        
    }
    
    private func restoreState() {
        
        guard let encodedState = UserDefaults.standard.object(forKey: storedStateKey) as? Data else {
            return
        }
        
        guard let state = try? JSONDecoder().decode(State.self, from: encodedState) else {
            return
        }
        
        self.urlToFileMap = state.urlMap
        self.fileCounter = state.fileCounter
        
    }
    
}

extension DiskCache {
    
    enum Error: Swift.Error {
        case userDocumentDirectoryNotFound
    }
    
    struct State: Codable {
        
        let fileCounter: Int
        let urlMap: [URL: String]
        
    }
    
}
