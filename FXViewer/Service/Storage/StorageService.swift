//
//  StorageService.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//

import Foundation

public protocol Storage {
    func getValue<T>(for key: String) -> T? where T: StorageObject
    func set(_ value: StorageObject, for key: String)
    func removeValue(for key: String)
    func clear()
}

enum StorageKeys {
    static let api = "storage_apiKey"
    static let currencies = "storage_currencies"
    static let favorites = "storage_favorites"
}
