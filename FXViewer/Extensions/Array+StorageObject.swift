//
//  Array+StorageObject.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import Foundation

struct ByteArray: StorageObject {
    let values: [UInt8]

    func toData() -> Data? {
        Data(values)
    }
    
    init(_ values: [UInt8]) {
        self.values = values
    }

    init?(from data: Data) {
        self.values = Array(data)
    }
}

struct StringArray: StorageObject {
    let values: [String]

    func toData() -> Data? {
        try? JSONSerialization.data(withJSONObject: values, options: [])
    }
    
    init(_ values: [String]) {
        self.values = values
    }

    init?(from data: Data) {
        guard let array = try? JSONSerialization.jsonObject(with: data) as? [String] else {
            return nil
        }
        self.values = array
    }
}

//// MARK: - Для массива String
//extension Array: StorageObject where Element == String {
//    public func toData() -> Data? {
//        try? JSONSerialization.data(withJSONObject: self, options: [])
//    }
//
//    public init?(from data: Data) {
//        guard let array = try? JSONSerialization.jsonObject(with: data) as? [String] else {
//            return nil
//        }
//        self = array
//    }
//}
//extension Array: StorageObject where Element: StorageObject {
//    public func toData() -> Data? {
//        return Data(self.compactMap { $0.toData() })
//    }
//    
//    public init?(from data: Data) {
//        var elements: [Element] = []
//        var offset = 0
//        
//        while offset < data.count {
//            let slice = data[offset...]
//            guard let element = Element(from: Data(slice)) else { return nil }
//            elements.append(element)
//            offset += element.toData()?.count ?? .zero
//        }
//        
//        self = elements
//    }
//}
