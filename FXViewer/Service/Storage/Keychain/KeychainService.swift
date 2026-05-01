//
//  KeychainService.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//

import Foundation
import KeychainSwift

final class KeychainService: Storage {
    private let keychain = KeychainSwift()
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    func getValue<T>(for key: String) -> T? where T: StorageObject {
        guard let value = keychain.getData(key).flatMap({ T(from: $0) }) else {
            return keychain.get(key) as? T
        }
        return value
    }
    
    func set(_ value: any StorageObject, for key: String) {
        guard let stringValue = value as? String else {
            keychain.set(value.toData() ?? Data(), forKey: key)
            return
        }
        keychain.set(stringValue, forKey: key)
    }
    
    func removeValue(for key: String) {
        keychain.delete(key)
    }
    
    func clear() {
        keychain.clear()
    }
}
