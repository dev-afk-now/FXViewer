//
//  HomeCoordinator.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import UIKit

class HomeCoordinator: Coordinator {
    unowned var navigationController: UINavigationController
    unowned var parentCoordinator: Coordinator
    var childCoordinators: [Coordinator] = []
    private let repository = CurrencyRepositoryImpl()
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self, repository: repository)
        let view = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(view, animated: true)
    }
    
    func back() {}
    
    func openFavorites() {
        let favoritesCoordinator = FavoritesCoordinator(
            navigationController: navigationController,
            parentCoordinator: self,
            repository: repository
        )
        self.childCoordinators.append(favoritesCoordinator)
        favoritesCoordinator.start()
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
