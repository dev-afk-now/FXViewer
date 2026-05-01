//
//  FavoritesCoordinator.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    unowned var navigationController: UINavigationController
    private unowned var parentCoordinator: Coordinator
    var childCoordinators: [Coordinator] = []
    private let repository: CurrencyRepository<CurrencyRepositoryState>
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator,
        repository: CurrencyRepository<CurrencyRepositoryState>
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.repository = repository
    }
    
    func start() {
        let viewModel = FavoritesViewModel(coordinator: self, repository: repository)
        let view = FavoritesViewController(viewModel: viewModel)
        navigationController.pushViewController(view, animated: true)
    }
    
    func back() {
        parentCoordinator.childDidFinish(self)
        navigationController.popViewController(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
