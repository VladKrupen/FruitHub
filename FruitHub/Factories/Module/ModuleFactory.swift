//
//  ModuleFactory.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit
import Combine

final class ModuleFactory {
    
    private static let dataVerificationManager = DataVerificationManager()
    private static let firebaseManager = FirebaseManager()
    private static let coreDataManager = CoreDataManager()
    private static var sharedUserPublisher: PassthroughSubject<User, Never> = .init()
    
    static func createSplashModule() -> SplashViewController {
        let splashViewController = SplashViewController()
        let splashViewModel = SplashViewModel()
        splashViewController.viewModel = splashViewModel
        return splashViewController
    }
    
    static func createWelcomeModule() -> WelcomeViewController {
        let welcomeViewController = WelcomeViewController()
        let welcomeViewModel = WelcomeViewModel()
        welcomeViewController.viewModel = welcomeViewModel
        return welcomeViewController
    }
    
    static func createEnterNameModule() -> EnterNameViewController {
        let enterNameViewController = EnterNameViewController()
        let enterNameViewModel = EnterNameViewModel(userDataVerification: dataVerificationManager,
                                                    coreDataCreationUser: coreDataManager)
        enterNameViewController.viewModel = enterNameViewModel
        return enterNameViewController
    }
    
    static func createHomeModule() -> HomeViewController {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel(firebaseManager: firebaseManager,
                                          coreDataReceivingUser: coreDataManager,
                                          coreDataFruitSalads: coreDataManager,
                                          coreDataUpdatingFruitSalad: coreDataManager,
                                          userPublisher: sharedUserPublisher)
        homeViewController.viewModel = homeViewModel
        return homeViewController
    }
    
    static func createSaladModule(fruitSalad: FruitSalad, callingModule: CallingModule) -> SaladViewController {
        let counterManager = CounterManager()
        let saladController = SaladViewController()
        let saladViewModel = SaladViewModel(counterManager: counterManager,
                                            fruitSalad: fruitSalad,
                                            coreDataUpdatingFruitSalad: coreDataManager,
                                            callingModule: callingModule)
        saladController.viewModel = saladViewModel
        return saladController
    }
    
    static func createOrderListModule() -> OrderListViewController {
        let orderListViewController = OrderListViewController()
        let orderListViewModel = OrderListViewModel(coreDataReceivingOrderList: coreDataManager,
                                                    coreDataUpdatingFruitSalad: coreDataManager)
        orderListViewController.viewModel = orderListViewModel
        return orderListViewController
    }
    
    static func createCompleteDetailsModule() -> CompleteDetailsViewController {
        let completeDetailsViewController = CompleteDetailsViewController()
        let completeDetailsViewModel = CompleteDetailsViewModel(deliveryDataVerification: dataVerificationManager)
        completeDetailsViewController.viewModel = completeDetailsViewModel
        return completeDetailsViewController
    }
    
    static func createCardDetailsModule() -> CardDetailsViewController {
        let cardDetailsViewController = CardDetailsViewController()
        let cardDetailsViewModel = CardDetailsViewModel(cardDataVerification: dataVerificationManager)
        cardDetailsViewController.viewModel = cardDetailsViewModel
        return cardDetailsViewController
    }
    
    static func createOrderCompleteModule() -> OrderCompleteViewController {
        let orderCompleteViewController = OrderCompleteViewController()
        let orderCompleteViewModel = OrderCompleteViewModel(coreDataReceivingOrderList: coreDataManager,
                                                            coreDataUpdatingFruitSalad: coreDataManager)
        orderCompleteViewController.viewModel = orderCompleteViewModel
        return orderCompleteViewController
    }
    
    static func createMenuModule() -> MenuViewController {
        let menuViewController = MenuViewController()
        let menuViewModel = MenuViewModel(coreDataUpdatingUser: coreDataManager,
                                          coreDataReceivingUser: coreDataManager,
                                          userPublisher: sharedUserPublisher)
        menuViewController.viewModel = menuViewModel
        return menuViewController
    }
}
