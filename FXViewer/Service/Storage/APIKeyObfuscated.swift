//
//  ObfuscatedAPIKey.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//


import Foundation
import Security
import UIKit

// MARK: - Obfuscation helpers

final class KeychainDecorator {
    private let tokenStorageKey = "app.apiKey"
    private let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func prepareIfNeeded() {
        if storage.getValue(for: tokenStorageKey) != nil {
            return
        }
        guard let revealed = ObfuscatedAPIKey.reveal() else { return }
        _ = KeychainHelper.save(key: storageKey, value: revealed)
    }
    
    func load() -> String? {
        return KeychainHelper.load(key: storageKey)
    }
    
    func clear() {
        KeychainHelper.delete(key: storageKey)
    }
}

// MARK: - Usage example
func prepareApiKeyIfNeeded() {
    let storageKey = "com.iosnik.FXViewer.apiKey"

    if let existing = KeychainHelper.load(key: storageKey) {
        print("Keychain already has key (length \(existing.count))")
        return
    }

    guard let apiKey = ObfuscatedAPIKey.reveal() else {
        print("Failed to reveal API key")
        return
    }

    if KeychainHelper.save(key: storageKey, value: apiKey) {
        print("Saved API key into Keychain")
    } else {
        print("Failed to save API key")
    }
}

struct APIKeyObfuscator {
    private static let mask: UInt8 = 0x5A
    
    static let apiKeyObfuscatedBytes: [UInt8] = [
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
    
    static func reveal(from obfuscated: String) -> String? {
        guard let data = Data(base64Encoded: obfuscated) else { return nil }
        let deXOR = data.map { $0 ^ mask }
        guard let base64 = String(bytes: deXOR, encoding: .utf8),
              let originalData = Data(base64Encoded: base64),
              let original = String(data: originalData, encoding: .utf8) else {
            return nil
        }
        return original
    }
}
