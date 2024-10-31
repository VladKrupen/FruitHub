//
//  CoordinatorFactory.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class CoordinatorFactory {
    static let userDefaultsManager = UserDefaultsManager()
    
    static func createAppCoordinator(navigationController: UINavigationController) -> AppCoordinatorProtocol {
        let appCoordinator = AppCoordinator(navigationController: navigationController,
                                            appLaunchChecking: userDefaultsManager,
                                            appLaunchSetting: userDefaultsManager)
        return appCoordinator
    }
    
    static func createSplashCoordinator(navigationController: UINavigationController) -> CoordinatorProtocol {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        return splashCoordinator
    }
    
    static func createWelcomeCoordinator(navigationController: UINavigationController) -> CoordinatorProtocol {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        return welcomeCoordinator
    }
    
    static func createEnterNameCoordinator(navigationController: UINavigationController) -> CoordinatorProtocol {
        let enterNameCoordinator = EnterNameCoordinator(navigationController: navigationController)
        return enterNameCoordinator
    }
    
    static func createHomeCoordiantor(navigationController: UINavigationController) -> CoordinatorProtocol {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        return homeCoordinator
    }
}
