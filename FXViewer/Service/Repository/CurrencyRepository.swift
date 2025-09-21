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
    
    // MARK: - Published properties -
    
//    @Published var
    
    // MARK: - Private properties -
    
    private let apiClient: GraphQLServiceProtocol
    private let errorHandler = ErrorHandler()
    
    init(apiClient: GraphQLServiceProtocol = DIContainer.shared.graphQLService) {
        self.apiClient = apiClient
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
                            .success(self?.assambleCurrencyList(all: currencies, rates: latestRates) ?? [])
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
                    image: "https://raw.githubusercontent.com/Lissy93/currency-flags/master/assets/flags_svg/usd.svg"
                )
            )
            allCurrencies.removeValue(forKey: match.code)
        }
        return result
    }
}
