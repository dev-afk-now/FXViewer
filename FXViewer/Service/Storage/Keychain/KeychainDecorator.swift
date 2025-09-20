//
//  KeychainDecorator.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//

final class KeychainDecorator: Storage {
    private let tokenStorageKey = StorageKeys.apiKey
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func getValue<T>(for key: String) -> T? where T : StorageObject {
        if key == tokenStorageKey,
           let obfuscated: [UInt8] = storage.getValue(for: key),
           let revealed = APIKeyObfuscated.reveal(obfuscated) {
            return (revealed as StorageObject) as? T
        } else {
            return storage.getValue(for: key)
        }
    }
    
    func set(_ value: any StorageObject, for key: String) {
        storage.set(value, for: key)
    }
    
    func removeValue(for key: String) {
        storage.removeValue(for: tokenStorageKey)
    }
    
    func clear() {
        storage.clear()
    }
    
    func prepareIfNeeded() {
        defer { APIKeyObfuscated.obfuscatedBytes = [] }
        
        guard let existing: [UInt8] = storage.getValue(for: tokenStorageKey) else {
            set(APIKeyObfuscated.obfuscatedBytes, for: tokenStorageKey)
            return
        }
        print(existing)
    }
}
