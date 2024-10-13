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
//        showOrderListModule()
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
        orderListController.viewModel?.completionHandler = { [weak self] in
            self?.showCompleteDetailsModule()
        }
    }
    
    private func showCompleteDetailsModule() {
        let completeDetailsController = ModuleFactory.createCompleteDetailsModule()
        if let sheetController = completeDetailsController.sheetPresentationController {
            sheetController.detents = [.custom(resolver: { context in
                return 450
            })]
        }
        navigationController.present(completeDetailsController, animated: true)
        completeDetailsController.viewModel?.completionHandler = { [weak self] actions in
            switch actions {
            case .dismissButton:
                completeDetailsController.dismiss(animated: true)
            case .payOnDeliveryButton:
                print()
            case .payWithCardButton:
                self?.showCardDetailsModule(controller: completeDetailsController)
            }
        }
    }
    
    private func showCardDetailsModule(controller: UIViewController) {
        let cardDetailsController = ModuleFactory.createCardDetailsModule()
        if let sheetController = cardDetailsController.sheetPresentationController {
            sheetController.detents = [.custom(resolver: { context in
                return 570
            })]
            
        }
        controller.present(cardDetailsController, animated: true)
        cardDetailsController.viewModel?.completionHandler = { actions in
            switch actions {
            case .dismissButton:
                cardDetailsController.dismiss(animated: true)
            case .completeOrderButton:
                print()
            }
        }
    }
}
