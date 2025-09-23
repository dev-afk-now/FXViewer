//
//  CurrencyRepositoryImpl.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import Collections

final class CurrencyRepositoryImpl: CurrencyRepository<CurrencyRepositoryState> {
    
    // MARK: - Private properties -
    
    private let apiClient: GraphQLServiceProtocol
    private let errorHandler = ErrorHandler()
    private let storage: Storage
    private var currenciesDict = OrderedDictionary<String, CurrencyModel>()
    private var list: [CurrencyModel] = []
    private var favoriteCodes: [String] = [] {
        didSet { print(favoriteCodes) }
    }
    
    // MARK: - Init -
    
    init(
        apiClient: GraphQLServiceProtocol = DIContainer.shared.graphQLService,
        storage: Storage = DIContainer.shared.storage
    ) {
        self.apiClient = apiClient
        self.storage = storage
        super.init(state: .idle)
    }
    
    // MARK: - Internal methods -
    
    override func fetchCurrencyList() {
        retrieveFavoriteCodes()
        apiClient.fetchCurrencies { [weak self] result in
            guard let self else {
                self?.updateState(newValue: .error(.unknown))
                return
            }
            switch result {
            case .success(let currencies):
                self.apiClient.fetchEuroRates { [weak self] result in
                    guard let self else {
                        self?.updateState(newValue: .error(.unknown))
                        return
                    }
                    handleLatestResponse(result, currencies)
                }
            case .failure(let error):
                self.processFailure(error)
            }
        }
    }
    
    override func switchCurrencyAsFavorite(by code: String) {
        if let index = favoriteCodes.firstIndex(of: code) {
            favoriteCodes.remove(at: index)
            currenciesDict[code]?.isFavorite = false
        } else {
            favoriteCodes.append(code)
            currenciesDict[code]?.isFavorite = true
        }
        updateFavoriteCodes(favoriteCodes)
        updateStoredCurrencies(currenciesDict)
        updateState(newValue: .updated(currenciesDict.map { $1 }))
    }
    
    override func fetchFavorites() -> [CurrencyModel] {
        favoriteCodes.compactMap { currenciesDict[$0] }
    }
    
    // MARK: - Private methods -
    
    private func assambleCurrencyList(
        all currencies: [CurrencyNetworkModel],
        rates: [LatestNetworkModel]
    ) {
        var allCurrencies = Dictionary(
            uniqueKeysWithValues: currencies.map { ($0.code, $0) }
        )
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
                    image: Globals.baseImageURL + match.code.lowercased() + ".svg",
                    date: rate.date,
                    isFavorite: favoriteCodes.contains(match.code)
                )
            )
            allCurrencies.removeValue(forKey: match.code)
        }
        saveCurrencies(result)
        updateState(newValue: .updated(result))
    }
    
    private func saveCurrencies(_ currencies: [CurrencyModel]) {
        currenciesDict = OrderedDictionary(
            uniqueKeysWithValues: currencies.map { ($0.code, $0) }
        )
        storage.set(
            currenciesDict,
            for: StorageKeys.currencies
        )
    }
    
    private func updateStoredCurrencies(_ dictionary: OrderedDictionary<String, CurrencyModel>) {
        storage.set(
            dictionary,
            for: StorageKeys.currencies
        )
    }
    
    private func retrieveStoredCurrencies() {
        guard
            let dictionary: OrderedDictionary<String, CurrencyModel> = storage.getValue(for: StorageKeys.currencies) else {
            return
        }
        currenciesDict = dictionary
    }
    
    private func retrieveFavoriteCodes() {
        guard
            let favoriteCodes: StringArray = storage.getValue(for: StorageKeys.favorites) else {
            return
        }
        self.favoriteCodes = favoriteCodes.values
    }
    
    private func updateFavoriteCodes(_ codes: [String]) {
        storage.set(
            StringArray(codes),
            for: StorageKeys.favorites
        )
    }
    
    private func processFailure(_ error: Error) {
        retrieveStoredCurrencies()
        let parsed = errorHandler.mapError(error)
        favoriteCodes.forEach { currenciesDict[$0]?.isFavorite = true }
//        updateState(
//            newValue: .error(errorHandler.mapError(error))
//        )
        updateState(
            newValue: currenciesDict.isEmpty
            ? .error(parsed)
            : .cached(currenciesDict.map { $1 })
        )
    }
}

// MARK: - Private extensions

private extension CurrencyRepositoryImpl {
    func handleLatestResponse(
        _ result: Result<[LatestNetworkModel], Error>,
        _ currencies: [CurrencyNetworkModel]
    ) {
        switch result {
        case .success(let latestRates):
            self.assambleCurrencyList(all: currencies, rates: latestRates)
        case .failure(let error):
            self.processFailure(error)
        }
    }
}
