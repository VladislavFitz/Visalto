//
//  DiskCache.swift
//  Visalto
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

final class DiskCache {
    
    private var urlMap: [URL: URL]
    private let lock: NSObject
    private let cacheFolderURL: URL
    private let fileManager: FileManager
    private var fileCounter: Int
    
    private let folderPath = "visaltoCache"
    private let filePrefix = "visaltoCachedImage"
    
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
        
        if !fileManager.fileExists(atPath: cacheFolderURL.path) {
            try fileManager.createDirectory(atPath: cacheFolderURL.path, withIntermediateDirectories: true, attributes: .none)
        }
        
    }
    
    func fileURL(for url: URL) -> URL? {
        
        if url.isFileURL {
            return url
        }
        
        return urlMap[url]
        
    }
    
    func contains(_ key: URL) -> Bool {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        return urlMap[key] != nil
        
    }
    
    func store(_ data: Data, forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        if key.isFileURL {
            return
        }
        
        let fileID = self.fileID()
        let fileURL = self.fileURL(forFileWithID: fileID)
        
        fileManager.createFile(atPath: fileURL.path, contents: data, attributes: .none)

        urlMap[key] = fileURL
        
    }
    
    func remove(forKey key: URL) {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        guard let fileURL = urlMap[key] else {
            return
        }
        
        urlMap.removeValue(forKey: key)
        try? fileManager.removeItem(at: fileURL)
        
    }
    
    func clear() {
        
        objc_sync_enter(lock)
        defer { objc_sync_exit(lock) }
        
        urlMap.removeAll()
        
        for fileURL in urlMap.values {
            try? fileManager.removeItem(at: fileURL)
        }
        
    }
    
    private func fileID() -> String {
        let fileID = "\(filePrefix)\(fileCounter)"
        fileCounter += 1
        return fileID
    }
    
    private func fileURL(forFileWithID fileID: String) -> URL {
        return cacheFolderURL.appendingPathComponent(fileID)
    }
    
}

extension DiskCache {
    
    enum Error: Swift.Error {
        case userDocumentDirectoryNotFound
    }
    
}
