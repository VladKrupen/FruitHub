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
        homeController.viewModel?.completionHandler = { [weak self] actions, fruitSalad in
            switch actions {
            case .saladCellPressed:
                guard let fruitSalad else { return }
                self?.showSaladModule(fruitSalad: fruitSalad)
            case .basketPressed:
                self?.showOrderListModule()
            }
        }
    }
    
    private func showSaladModule(fruitSalad: FruitSalad) {
        let saladController = ModuleFactory.createSaladModule(fruitSalad: fruitSalad)
        navigationController.pushViewController(saladController, animated: true)
        saladController.viewModel?.completionHandler = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
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
        completeDetailsController.viewModel?.completionHandler = { [weak self, weak completeDetailsController] actions in
            switch actions {
            case .dismissButton:
                completeDetailsController?.dismiss(animated: true)
            case .payOnDeliveryButton:
                guard let completeDetailsController = completeDetailsController else { return }
                self?.showOrderCompleteModule(controller: completeDetailsController)
            case .payWithCardButton:
                guard let completeDetailsController = completeDetailsController else { return }
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
        cardDetailsController.viewModel?.completionHandler = { [weak self, weak cardDetailsController] actions in
            switch actions {
            case .dismissButton:
                cardDetailsController?.dismiss(animated: true)
            case .completeOrderButton:
                guard let cardDetailsController = cardDetailsController else { return }
                self?.showOrderCompleteModule(controller: cardDetailsController)
            }
        }
    }
    
    private func showOrderCompleteModule(controller: UIViewController) {
        let orderCompleteController = ModuleFactory.createOrderCompleteModule()
        orderCompleteController.modalPresentationStyle = .fullScreen
        orderCompleteController.modalTransitionStyle = .crossDissolve
        
        controller.present(orderCompleteController, animated: true) { [weak self] in
            self?.navigationController.popToRootViewController(animated: false)
        }
        orderCompleteController.viewModel?.completionHandler = { [weak self, weak orderCompleteController] in
            self?.navigationController.dismiss(animated: true) {
                orderCompleteController?.dismiss(animated: true)
            }
        }
    }
}
