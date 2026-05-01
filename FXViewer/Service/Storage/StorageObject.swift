//
//  StorageObject.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//

import Foundation
import OrderedCollections

public protocol StorageObject {
    init?(from data: Data)
    func toData() -> Data?
}

public extension StorageObject where Self: Codable {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        return encoded
    }
    
    init?(from data: Data) {
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(Self.self, from: data) else {
            return nil
        }
        self = decoded
    }
}

extension String: StorageObject {}
extension UInt8: StorageObject {
    public func toData() -> Data? {
        return Data([self])
    }
    
    public init?(from data: Data) {
        guard let value = data.first else { return nil }
        self = value
    }
}
extension OrderedDictionary: StorageObject where Key == String, Value: Codable {}
