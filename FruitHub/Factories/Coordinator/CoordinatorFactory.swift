//
//  CoordinatorFactory.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class CoordinatorFactory {
    static func createAppCoordinator(navigationController: UINavigationController) -> AppCoordinatorProtocol {
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        return appCoordinator
    }
    
    static func createSplashCoordinator(navigationController: UINavigationController) -> CoordinatorProtocol {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        return splashCoordinator
    }
}
