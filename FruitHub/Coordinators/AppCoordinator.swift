//
//  AppCoordinator.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    private var childCoordinator: [CoordinatorProtocol] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSplashFlow()
    }
    
    private func showSplashFlow() {
        let splashCoordinator = CoordinatorFactory.createSplashCoordinator(navigationController: navigationController)
        childCoordinator.append(splashCoordinator)
        splashCoordinator.start()
        splashCoordinator.flowCompletionHandler = { [weak self] in
            self?.showWelcomeFlow()
        }
    }
    
    private func showWelcomeFlow() {
        let welcomeCoordinator = CoordinatorFactory.createWelcomeCoordinator(navigationController: navigationController)
        childCoordinator.append(welcomeCoordinator)
        welcomeCoordinator.start()
        welcomeCoordinator.flowCompletionHandler = { [weak self] in
            self?.showEnterNameFlow()
        }
    }
    
    private func showEnterNameFlow() {
        let enterNameCoordinator = CoordinatorFactory.createEnterNameCoordinator(navigationController: navigationController)
        childCoordinator.append(enterNameCoordinator)
        enterNameCoordinator.start()
        enterNameCoordinator.flowCompletionHandler = {
            
        }
    }
}
