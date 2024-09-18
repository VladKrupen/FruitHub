//
//  WelcomeCoordinator.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class WelcomeCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showWelcomeModule()
    }
    
    func showWelcomeModule() {
        let welcomeCoordinator = ModuleFactory.createWelcomeModule()
        navigationController.setViewControllers([welcomeCoordinator], animated: true)
        welcomeCoordinator.viewModel?.completionHandler = { [weak self] in
            self?.flowCompletionHandler?()
        }
    }
}
