//
//  GraphQLService.swift
//  FXViewer
//
//  Created by Nik Dub on 9/18/25.
//

import Apollo
import SwopAPI
import Foundation

protocol GraphQLServiceProtocol {
    func fetchEuroLatest(id: String)
    func fetchCurrencies()
}

final class GraphQLService: GraphQLServiceProtocol {
    typealias Latest = LatestEuroQuery.Data.Latest
    
    private let client: ApolloClient

    init(client: ApolloClient) {
        self.client = client
    }
    
    func fetchCurrencies() {
        let query = CurrenciesQuery()
        client.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: DispatchQueue.global()
        ) { result in
            print(result)
            switch result {
            case .success(let success):
                let items = success.data?.currencies
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchEuroLatest(id: String){
        let query = LatestEuroQuery()
        client.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: DispatchQueue.global()
        ) { result in
            print(result)
            switch result {
            case .success(let success):
                let items = success.data?.latest
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
