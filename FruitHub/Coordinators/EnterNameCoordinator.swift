//
//  EnterNameCoordinator.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class EnterNameCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    
    var flowCompletionHandler: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showEnterNameModule()
    }
    
    private func showEnterNameModule() {
        let enterNameController = ModuleFactory.createEnterNameModule()
        navigationController.setViewControllers([enterNameController], animated: true)
        enterNameController.viewModel?.completionHandler = { [weak self] in
            self?.flowCompletionHandler?()
        }
    }
}
