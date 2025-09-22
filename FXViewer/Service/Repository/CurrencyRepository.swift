//
//  CurrencyRepository.swift
//  FXViewer
//
//  Created by Nik Dub on 9/21/25.
//

protocol CurrencyRepository {
    func getCurrencyList(
        _ completion: @escaping (Result<[CurrencyModel], FXError>) -> ()
    )
}

final class CurrencyRepositoryImpl: CurrencyRepository {
    
    // MARK: - Private properties -
    
    private let apiClient: GraphQLServiceProtocol
    private let errorHandler = ErrorHandler()
    private let storage: Storage
    private var currenciesDict: [String: CurrencyModel] = [:]
    
    init(
        apiClient: GraphQLServiceProtocol = DIContainer.shared.graphQLService,
        storage: Storage = DIContainer.shared.storage
    ) {
        self.apiClient = apiClient
        self.storage = storage
    }
    
    func getCurrencyList(
        _ completion: @escaping (Result<[CurrencyModel], FXError>) -> ()
    ) {
        apiClient.fetchCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.apiClient.fetchEuroRates { [weak self] result in
                    switch result {
                    case .success(let latestRates):
                        completion(
                            .success(
                                self?.assambleCurrencyList(all: currencies, rates: latestRates) ?? []
                            )
                        )
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
    ) -> [CurrencyModel] {
        var allCurrencies = Dictionary(uniqueKeysWithValues: currencies.map { ($0.code, $0) })
        var result: [CurrencyModel] = []
        for rate in rates {
            guard let match = allCurrencies[rate.code] else {
                continue
            }
            result.append(
                CurrencyModel(
                    name: match.name,
                    code: match.code,
                    price: rate.price,
                    image: Globals.baseImageURL + match.code.lowercased() + ".svg"
                )
            )
            allCurrencies.removeValue(forKey: match.code)
        }
        return result
    }
    
    private func saveCurrencies(_ currencies: [CurrencyModel]) {
        storage.set(
            Dictionary(
                uniqueKeysWithValues: currencies.map { ($0.code, $0) }
            ),
            for: StorageKeys.currencies
        )
    }
    
    private func setCurrencyAsFavorite(by code: String, value: Bool) {
        let currencies = getStoredCurrencies()
    }
    
    private func getStoredCurrencies() -> [CurrencyModel] {
        guard let dictionary: [String: CurrencyModel] = storage.getValue(for: StorageKeys.currencies) else {
            return []
        }
        currenciesDict = dictionary
        return dictionary.map { $1 }
    }
    
//    private func getFavoriteCodes() -> [String] {
//        guard let favoriteCodes: [String] = storage.getValue(for: "") else {
//            return []
//        }
//        return favoriteCodes.compactMap { currenciesDict[$0]?.name }
//    }
}
