//
//  CurrencyNetworkModel.swift
//  FXViewer
//
//  Created by Nik Dub on 28.04.2025.
//

import UIKit

struct CurrencyNetworkModel: Codable {
    let baseCurrency: String
    let quoteCurrency: String
    let quote: Double
    let date: String
    
//    init(thumbnail: UIImage) {
//        self.thumbnail = thumbnail
//    }
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: CurrencyModel, rhs: CurrencyModel) -> Bool {
//        lhs.id == rhs.id
//    }
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case quote, date
    }
}

typealias CurrencyResponseModel = [CurrencyModel]
