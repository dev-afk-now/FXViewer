//
//  FavoritesViewModel.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import Foundation
import Combine

enum FavoritesViewModelState: ViewModelState, Equatable {
    case idle
    case updated([CurrencyModel])
}

final class FavoritesViewModel: BaseViewModel<FavoritesViewModelState> {
    
    // MARK: - Private properties
    
    private unowned let coordinator: FavoritesCoordinator
    private let repository: CurrencyRepository<CurrencyRepositoryState>
    
    // MARK: - Init
    
    init(
        coordinator: FavoritesCoordinator,
        repository: CurrencyRepository<CurrencyRepositoryState>
    ) {
        self.repository = repository
        self.coordinator = coordinator
        super.init(state: .idle)
    }
    
    // MARK: - Internal methods
    
    override func start() {
        retrieveFavorites()
    }
    
    func removeCurrency(_ code: String) {
        repository.switchCurrencyAsFavorite(by: code)
    }
    
    func backToHome() {
        coordinator.back()
    }
}

// MARK: - Extensions

extension FavoritesViewModel {
    func retrieveFavorites() {
        let list = repository.fetchFavorites()
        updateState(newValue: list.isEmpty ? .idle : .updated(list))
    }
}
