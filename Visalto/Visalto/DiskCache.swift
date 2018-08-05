//
//  DiskCache.swift
//  Visalto
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

final class DiskCache {
    
    private var urlMap: [URL: String]
    private var fileCounter: Int
    private let lock: NSObject
    private let cacheFolderURL: URL
    private let fileManager: FileManager
    
    private let folderPath = "visaltoCache"
    private let filePrefix = "visaltoCachedImage"
    private let storedStateKey = "visalto.diskCache.state"
    
    var isEmpty: Bool {
        return urlMap.isEmpty
    }
    
    init(fileManager: FileManager = .default) throws {
        
        self.urlMap = [:]
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
        
        guard let fileID = urlMap[url] else {
            return .none
        }
        
        return fileURL(forFileWithID: fileID)
        
    }
    
    func contains(_ key: URL) -> Bool {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        return urlMap[key] != nil
        
    }
    
    func store(_ data: Data, forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        if key.isFileURL || urlMap[key] != nil {
            return
        }
        
        let fileID = self.fileID()
        let fileURL = self.fileURL(forFileWithID: fileID)
        
        fileManager.createFile(atPath: fileURL.path, contents: data, attributes: .none)

        urlMap[key] = fileID
        
        storeState()
        
    }
    
    func remove(forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        guard let fileID = urlMap[key] else {
            return
        }
        
        let fileURL = self.fileURL(forFileWithID: fileID)
        
        urlMap.removeValue(forKey: key)
        try? fileManager.removeItem(at: fileURL)
        
        storeState()
        
    }
    
    func clear() {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        urlMap.removeAll()
        fileCounter = 0
        
        for fileID in urlMap.values {
            let fileURL = self.fileURL(forFileWithID: fileID)
            try? fileManager.removeItem(at: fileURL)
        }
        
        storeState()
        
    }
    
    private func fileID() -> String {
        let fileID = "\(filePrefix)\(fileCounter)"
        fileCounter += 1
        return fileID
    }
    
    private func fileURL(forFileWithID fileID: String) -> URL {
        return cacheFolderURL.appendingPathComponent(fileID)
    }
    
    private func storeState() {
        
        let state = State(fileCounter: fileCounter, urlMap: urlMap)
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
        
        self.urlMap = state.urlMap
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
