//
//  CurrencyRepository.swift
//  FXViewer
//
//  Created by Nik Dub on 9/21/25.
//

import Combine

class CurrencyRepository<State: RepositoryState> {
    @Published var state: State
    
    init(state: State) {
        self.state = state
    }
    
    func fetchCurrencyList() {}
    func fetchFavorites() -> [CurrencyModel] {
        fatalError("Method should be overriden in subclasses")
    }
    func switchCurrencyAsFavorite(by code: String) {}
    
    internal func updateState(newValue: State) {
        state = newValue
    }
}
