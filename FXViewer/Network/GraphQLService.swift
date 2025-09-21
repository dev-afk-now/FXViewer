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
    func fetchEuroLatest(_ completion: @escaping (Result<[LatestNetworkModel], Error>) -> ())
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
    
    func fetchEuroLatest(
        _ completion: @escaping (Result<[LatestNetworkModel], Error>) -> ()
    ) {
        let query = LatestEuroQuery()
        client.fetch(
            query: query,
            cachePolicy: .fetchIgnoringCacheData,
            queue: DispatchQueue.global()
        ) { [weak self] result in
            print(result)
            switch result {
            case .success(let success):
                guard let unwrapped = success.data else {
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

final class CurrencyRepository {
    private let apiClient: GraphQLServiceProtocol
    private let errorHandler = ErrorHandler()
    
    init(apiClient: GraphQLServiceProtocol) {
        self.apiClient = apiClient
    }
    func start() {
        
    }
    
    func getCurrencyList(
        _ completion: @escaping (Result<[CurrencyModel], FXError>) -> ()
    ) {
        apiClient.fetchCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.apiClient.fetchEuroLatest { [weak self] result in
                    switch result {
                    case .success(let latestRates):
                        break
                    case .failure(let error):
                        completion(.failure(self?.errorHandler.mapError(error) ?? .unknown))
                    }
                }
            case .failure(let error):
                completion(.failure(self?.errorHandler.mapError(error) ?? .unknown))
            }
        }
    }
    
    private func assambleCurrencyList(
        all currencies: [CurrencyNetworkModel],
        rates: [LatestNetworkModel]
    ) {
        var allCopy = currencies
        var result: [CurrencyModel] = []
        for rate in rates {
            guard let matchIndex = (allCopy.firstIndex { $0.code == rate.code }) else {
                continue
            }
            result.append(
                CurrencyModel(
                    name: allCopy[matchIndex].name,
                    code: allCopy[matchIndex].code,
                    price: rate.price,
                    image: 
                )
            )
            allCopy.remove(at: matchIndex)
        }
    }
}

final class ErrorHandler {
    func mapError(_ error: Error) -> FXError {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorNetworkConnectionLost:
            return .connectionLost
        case NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost:
            return .serverUnavailable
        case NSURLErrorBadServerResponse:
            return .badResponse
        default:
            return .unknown
        }
    }
}

//https://raw.githubusercontent.com/Lissy93/currency-flags/master/assets/flags_svg/code.svg
