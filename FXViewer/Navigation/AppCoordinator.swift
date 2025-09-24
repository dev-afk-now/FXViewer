//
//  AppCoordinator.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let firstCoordinator = HomeCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        childCoordinators.append(firstCoordinator)
        firstCoordinator.start()
    }
    
    func back() {
        // No-op: AppCoordinator is the root coordinator and can't go back
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

