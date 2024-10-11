//
//  HomeCoordinator.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class HomeCoordinator: CoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    var flowCompletionHandler: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHomeModule()
//        showSaladModule()
    }
    
    private func showHomeModule() {
        let homeController = ModuleFactory.createHomeModule()
        navigationController.setViewControllers([homeController], animated: true)
        homeController.viewModel?.completionHandler = { [weak self] actions in
            switch actions {
            case .saladCellPressed:
                self?.showSaladModule()
            case .basketPressed:
                self?.showOrderListModule()
            }
        }
    }
    
    private func showSaladModule() {
        let saladController = ModuleFactory.createSaladModule()
        navigationController.pushViewController(saladController, animated: true)
    }
    
    private func showOrderListModule() {
        let orderListController = ModuleFactory.createOrderListModule()
        navigationController.pushViewController(orderListController, animated: true)
    }
}
