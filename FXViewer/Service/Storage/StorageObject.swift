//
//  StorageObject.swift
//  FXViewer
//
//  Created by Nik Dub on 9/20/25.
//

import Foundation

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
extension Dictionary: StorageObject where Key == String, Value: Codable {}
//extension Array: StorageObject where Element == String {}
extension String: StorageObject {}
extension UInt8: StorageObject {
    public func toData() -> Data? {
        return Data([self])
    }
    
    public init?(from data: Data) {
        self = [UInt8](data).first ?? .zero
    }
}
extension Array: StorageObject where Element: StorageObject {
    public func toData() -> Data? {
        return Data(self.compactMap { $0.toData() }.flatMap { $0 })
    }
    
    public init?(from data: Data) {
        var elements: [Element] = []
        var offset = 0
        
        while offset < data.count {
            // пытаемся создать один элемент из оставшихся байт
            let slice = data[offset...]
            guard let element = Element(from: Data(slice)) else { return nil }
            elements.append(element)
            offset += element.toData()?.count ?? 0
        }
        
        self = elements
    }
}
//extension Array: StorageObject where Element == UInt8 {
//    public func toData() -> Data? {
//        return Data(self)
//    }
//    
//    public init?(from data: Data) {
//        self = [UInt8](data)
//    }
//}
