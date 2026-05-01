//
//  GraphQLResponseHandler.swift
//  FXViewer
//
//  Created by Nik Dub on 9/21/25.
//

import SwopAPI

class GraphQLResponseHandler {
    func map<D: DTOMappable>(_ dto: D) -> D.Model {
        dto.toDomain()
    }
}

protocol DTOMappable {
    associatedtype Model
    func toDomain() -> Model
}

extension LatestEuroQuery.Data.Latest: DTOMappable {
    func toDomain() -> LatestNetworkModel {
        LatestNetworkModel(
            code: self.quoteCurrency,
            price: self.quote,
            date: self.date
        )
    }
}

extension CurrenciesQuery.Data.Currency: DTOMappable {
    func toDomain() -> CurrencyNetworkModel {
        CurrencyNetworkModel(
            code: self.code,
            name: self.name
        )
    }
}
