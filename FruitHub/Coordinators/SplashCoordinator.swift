//
//  SplashCoordinator.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class SplashCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSplashModule()
    }
    
    private func showSplashModule() {
        let splashController = ModuleFactory.createSplashModule()
        navigationController.pushViewController(splashController, animated: true)
        
    }
}
