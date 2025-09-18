//
//  CurrencyModel.swift
//  FXViewer
//
//  Created by Nik Dub on 9/16/25.
//

import Foundation

struct CurrencyModel: Hashable {
    let id = UUID()
    let name: String
    let code: String
    let price: String
    let image: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension CurrencyModel {
    init() {
        self.init(
            name: .empty,
            code: .empty,
            price: .empty,
            image: .empty
        )
    }
    
    static var placeholderList: [CurrencyModel] {
        var result: [CurrencyModel] = []
        for _ in 0..<10 {
            result.append(CurrencyModel())
        }
        return result
    }
    
    var isEmpty: Bool { self.name.isEmpty && self.code.isEmpty }
}
