//
//  HomeCoordinator.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import UIKit

class HomeCoordinator: Coordinator {
    unowned var navigationController: UINavigationController
    var parentCoordinator: Coordinator
    var childCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        parentCoordinator: Coordinator
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let view = HomeViewController(viewModel: viewModel)
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
