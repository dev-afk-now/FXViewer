//
//  AppDelegate.swift
//  FXViewer
//
//  Created by Nik Dub on 31.03.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window = UIWindow()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let navigationController = UINavigationController()
        navigationController.additionalSafeAreaInsets = .zero
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
}

