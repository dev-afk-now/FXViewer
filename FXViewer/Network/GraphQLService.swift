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
    func fetchEuroRates(_ completion: @escaping (Result<[LatestNetworkModel], Error>) -> ())
    func fetchCurrencies(_ completion: @escaping (Result<[CurrencyNetworkModel], Error>) -> ())
}

final class GraphQLService: GraphQLServiceProtocol {
    typealias Latest = LatestEuroQuery.Data.Latest
    
    private let client: ApolloClient
    private let serialQueue = DispatchQueue(label: "graphqlservice_serial")
    private let responseHandler = GraphQLResponseHandler()
    
    init(client: ApolloClient) {
        self.client = client
    }
    
    func fetchCurrencies(
        _ completion: @escaping (Result<[CurrencyNetworkModel], Error>) -> ()
    ) {
        let query = CurrenciesQuery()
        client.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: serialQueue
        ) { result in
            print(result)
            switch result {
            case .success(let success):
                guard let unwrapped = success.data else {
                    return
                }
                completion(
                    .success(unwrapped.currencies.compactMap { self.responseHandler.map($0) })
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEuroRates(
        _ completion: @escaping (Result<[LatestNetworkModel], Error>) -> ()
    ) {
        let query = LatestEuroQuery()
        client.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: DispatchQueue.global()
        ) { [weak self] result in
            switch result {
            case .success(let success):
                guard let unwrapped = success.data else {
                    completion(.failure(FXError.unknown))
                    return
                }
                completion(
                    .success(unwrapped.latest.compactMap { self?.responseHandler.map($0) })
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
