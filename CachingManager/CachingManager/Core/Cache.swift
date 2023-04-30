/*
 * (c) 2023 ios8engineer Limited. All rights reserved.
 */

import Foundation

fileprivate let kCacheLabel = "com.ios8engineer.cache"
fileprivate let kCacheFileSuffix = ".\(kCacheLabel)"

class Cache {
    
    // MARK: - Properties
    private var keys: Set<String> = []
    private var localCache: [AnyHashable: AnyObject] = [:]
    private let queue = DispatchQueue(label: kCacheLabel)
    
    // MARK: - Initializers
    init() {
        queue.async { self.loadSavedKeys() }
    }
    
    // MARK: - Public Methods
    func removeObject(forKey key: String) {
        queue.async {
            self.keys.remove(key)
            self.localCache[key] = nil
            self.removeFromDisk(forKey: key)
        }
    }
    
    func save<T: Codable>(object: T, forKey key: String, lifeTime: TimeInterval) {
        queue.async {
            let objectToCache = Entry<T>(
                value: object,
                expirationDate: Date().addingTimeInterval(lifeTime)
            )
            
            self.keys.insert(key)
            self.localCache[key] = objectToCache as AnyObject
            self.saveToDisk(object: objectToCache, forKey: key)
        }
    }
    
    func object<T: Codable>(forKey key: String, completionQueue: DispatchQueue = .main, completion: @escaping (T?) -> Void) {
        queue.async {
            guard self.keys.contains(key) else { return completionQueue.async { completion(nil) } }
            
            // MARK: Check if was already loaded from a disk
            if let cachedObject = self.localCache[key] as? Entry<T> {
                if self.validate(object: cachedObject) {
                    return completionQueue.async { completion(cachedObject.value) }
                } else {
                    self.removeObject(forKey: key)
                    
                    return completionQueue.async { completion(nil) }
                }
            }
            
            // MARK: Check if was not loaded by exists on a disk
            if let diskCachedObject: Cache.Entry<T> = self.objectFromDisk(forKey: key) {
                if self.validate(object: diskCachedObject) {
                    self.localCache[key] = diskCachedObject
                    
                    return completionQueue.async { completion(diskCachedObject.value) }
                } else {
                    self.removeObject(forKey: key)
                    
                    return completionQueue.async { completion(nil) }
                }
            }
            
            // MARK: Was not cached yet
            return completionQueue.async { completion(nil) }
        }
    }
    
    func clearStorage() {
        queue.async {
            self.keys = []
            self.localCache = [:]
            
            let manager = FileManager.default
            
            guard let documentDirectory = try? manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true),
                  let files = try? manager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil) else { return }
            
            for file in files {
                guard file.lastPathComponent.hasSuffix(kCacheFileSuffix) else { continue }
                
                try? manager.removeItem(at: file)
            }
        }
    }
    
    // MARK: - Private Methods
    private func validate<T>(object: Cache.Entry<T>) -> Bool {
        return Date() < object.expirationDate
    }
    
    private func removeFromDisk(forKey key: String) {
        guard let folderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = folderURL.appendingPathComponent("\(key)\(kCacheFileSuffix)")
        
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func saveToDisk<T: Codable>(object: T, forKey key: String) {
        guard let dataToSave = try? JSONEncoder().encode(object),
              let folderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = folderURL.appendingPathComponent("\(key)\(kCacheFileSuffix)")
        
        try? dataToSave.write(to: fileURL)
    }
    
    private func objectFromDisk<T: Codable>(forKey key: String) -> T? {
        guard let folderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = folderURL.appendingPathComponent("\(key)\(kCacheFileSuffix)")
        
        guard let data = try? Data(contentsOf: fileURL),
              let cachedObject = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        
        return cachedObject
    }
    
    private func loadSavedKeys() {
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true),
              let files = try? manager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil) else { return }
        
        let savedObjects = files.filter({ $0.lastPathComponent.hasSuffix(kCacheFileSuffix) })
        keys = Set(savedObjects.map({ $0.lastPathComponent.replacingOccurrences(of: kCacheFileSuffix, with: "") }))
    }
    
}
