//
//  KeychainService.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//

import KeychainSwift

final class KeychainService {
    
    private let keychain = KeychainSwift()
    
    func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }
    
    func get(key: String) -> String? {
        keychain.get(key)
    }
    
    func clear() {
        keychain.clear()
    }
}

protocol Storage {
    
}
