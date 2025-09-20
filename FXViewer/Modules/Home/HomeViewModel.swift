//
//  HomeViewModel.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import Foundation
import Combine

enum HomeViewModelState: ViewModelState {
    case idle
    case started
    case loading
    case updated([CurrencyModel])
}

final class HomeViewModel: BaseViewModel<HomeViewModelState> {
    
    // MARK: - Published properties -
    
    @Published private(set) var query: String = .empty
//    @Published var repositoryItems: [SearchItemResponse] = []
    @Published var hasToMoreItemsToLoad: Bool = false
//    @Published var limitExceededResponse: ErrorResponse?
    @Published var shouldShowAlert: Bool = false
    
    // MARK: - Private properties
    
    private unowned let coordinator: HomeCoordinator
    private let apiClient: GraphQLServiceProtocol
    private var isFetchingMore: Bool = false
    private var task: Task<Void, Error>?
//    private let apiClient: SearchAPIClient
    
    private let debounceInterval: TimeInterval = 1
    
    private var totalRepositoryCount = 0
    private let itemsPerPage = 30 /// Provided default value in docs
//    private var nextPageIndex: Int {
//        guard repositoryItems.count > .zero else { return 1 }
//        return repositoryItems.count / itemsPerPage + 1
//    }
    
    // MARK: - Lifecycle
    
    init(
        coordinator: HomeCoordinator,
        apiClient: GraphQLServiceProtocol = DIContainer.shared.graphQLService
    ) {
        self.apiClient = apiClient
        self.coordinator = coordinator
        super.init(state: .idle)
    }
    
    override func start() {
//        $query
//            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
//            .filter { $0.count >= 3 || $0.isEmpty }
//            .removeDuplicates()
//            .sink
//        { newValue in
//            self.repositoryItems = []
//            self.totalRepositoryCount = .zero
//            self.hasToMoreItemsToLoad = false
//            if newValue.isEmpty {
//                self.updateState(newValue: .idle)
//                self.task?.cancel()
//                return
//            }
//            
//            self.updateState(newValue: .loading)
//            print("SET LOADING")
//            self.updateRepositoryList()
//        }
//        .store(in: &cancellables)
        self.updateState(newValue: .loading)
    }
    
    func fetchMoreRepositories() {
        if isFetchingMore { return }
        isFetchingMore.toggle()
//        updateRepositoryList(page: nextPageIndex)
    }
    
//    func openDetailed(model: CurrencyModel) {
//        coordinator.openDetiled(model)
//    }
}

// MARK: - Private extension

private extension HomeViewModel {
    func updateRepositoryList(page: Int = 1) {
//        task?.cancel()
//        task = Task { @MainActor [weak self] in
//            try Task.checkCancellation()
//            guard let self else { return }
//            do {
//                let response = try await self.apiClient.searchQuery(self.query, page)
//                try Task.checkCancellation()
//                self.handleResponse(response)
//            } catch NetworkError.requestLimitExceeded(let response) {
//                self.isFetchingMore = false
//                self.query = .empty
//                self.limitExceededResponse = response
//                self.shoudlShowAlert = true
//                self.updateState(newValue: .started)
//            } catch let error {
//                if Task.isCancelled {
//                    print("SET CANCELD")
//                    isFetchingMore = false
//                    self.hasToMoreItemsToLoad = false
//                    self.updateState(newValue: query.count < 3  ? .idle : .loading )
//                } else {
//                    print("SET FAILED")
//                    isFetchingMore = false
//                    self.hasToMoreItemsToLoad = false
//                    self.updateState(newValue: .failed)
//                }
//                print(error)
//            }
//        }
    }
    
    func handleResponse(_ response: String) {
        print("SET LOADED")
//        repositoryItems += response.items
//        totalRepositoryCount = response.totalCount
//        hasToMoreItemsToLoad = totalRepositoryCount > repositoryItems.count
//        isFetchingMore = false
//        updateState(newValue: .started)
    }
}
