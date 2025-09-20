//
//  APIKeyObfuscated.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//


import Foundation

final class KeychainDecorator: Storage {
    private let tokenStorageKey = "storage.apiKey"
    private let storage: Storage
    
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func getValue<T>(for key: String) -> T? where T : StorageObject {
        if key == tokenStorageKey,
           let obfuscated: [UInt8] = storage.getValue(for: tokenStorageKey),
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
        if let existing: [UInt8] = storage.getValue(for: tokenStorageKey) {
            return
        }
        set(APIKeyObfuscated.obfuscatedBytes, for: tokenStorageKey)
        APIKeyObfuscated.obfuscatedBytes = []
    }
}

struct APIKeyObfuscated {
    private static let mask: UInt8 = 0x5A
    
    static var obfuscatedBytes: [UInt8] = [
        0x4D, 0x35, 0x39, 0x4D, 0x77, 0x35, 0x37, 0x58,
        0x35, 0x78, 0x34, 0x4C, 0x6C, 0x4E, 0x61, 0x58,
        0x33, 0x35, 0x62, 0x6B, 0x34, 0x39, 0x33, 0x39,
        0x33, 0x39, 0x37, 0x58, 0x33, 0x35, 0x37, 0x58,
        0x32, 0x4F, 0x62, 0x36, 0x6A, 0x67, 0x33, 0x54,
        0x35, 0x77, 0x35, 0x39, 0x34, 0x4E, 0x6C, 0x59,
        0x37, 0x4E, 0x63, 0x4E, 0x35, 0x78, 0x34, 0x4D,
        0x32, 0x4E, 0x63, 0x4C, 0x35, 0x77, 0x35, 0x39,
        0x32, 0x39, 0x62, 0x38
    ]
    
    static func reveal(_ bytesArray: [UInt8]) -> String? {
        let deXOR = bytesArray.map { $0 ^ mask }
        guard let base64Str = String(bytes: deXOR, encoding: .utf8),
              let keyData = Data(base64Encoded: base64Str),
              let key = String(data: keyData, encoding: .utf8) else {
            return nil
        }
        return key
    }
}
