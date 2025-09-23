//
//  HomeViewModel.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import Foundation
import Combine

enum HomeViewModelState: ViewModelState, Equatable {
    case idle
    case loading
    case updated([CurrencyModel])
    case offline([CurrencyModel])
    case error(String)
}

final class HomeViewModel: BaseViewModel<HomeViewModelState> {
    
    // MARK: - Private properties
    
    private unowned let coordinator: HomeCoordinator
    private let repository: CurrencyRepository<CurrencyRepositoryState>
    
    // MARK: - Init
    
    init(
        coordinator: HomeCoordinator,
        repository: CurrencyRepository<CurrencyRepositoryState>
    ) {
        self.repository = repository
        self.coordinator = coordinator
        super.init(state: .idle)
    }
    
    override func start() {
        repository.$state
            .sink(receiveValue: handleRepositoryUpdate)
            .store(in: &cancellables)
        refresh()
    }
    
    func refresh() {
        updateState(newValue: .loading)
        repository.fetchCurrencyList()
    }
    
    func switchCurrencyAsFavorite(_ code: String) {
        repository.switchCurrencyAsFavorite(by: code)
    }
    
    func openFavorites() {
        coordinator.openFavorites()
    }
}

// MARK: - Private extension

private extension HomeViewModel {
    func handleRepositoryUpdate(_ state: CurrencyRepositoryState) {
        switch state {
        case .idle:
            updateState(newValue: .idle)
        case .updated(let list):
            updateState(newValue: .updated(list))
        case .error(let fXError):
            updateState(newValue: .error(fXError.message))
        case .cached(let cached):
            updateState(newValue: .offline(cached))
        }
    }
}
