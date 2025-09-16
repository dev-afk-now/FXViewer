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
        
        let viewController = HomeViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return true
    }
}

