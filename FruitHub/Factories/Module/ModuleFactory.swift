//
//  ModuleFactory.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class ModuleFactory {
    
    static let dataVerificationManager = DataVerificationManager()
    
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
        let enterNameViewModel = EnterNameViewModel(userDataVerification: dataVerificationManager)
        enterNameViewController.viewModel = enterNameViewModel
        return enterNameViewController
    }
    
    static func createHomeModule() -> HomeViewController {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel(firebaseManager: FirebaseManager())
        homeViewController.viewModel = homeViewModel
        return homeViewController
    }
    
    static func createSaladModule(fruitSalad: FruitSalad) -> SaladViewController {
        let counterManager = CounterManager()
        let saladController = SaladViewController()
        let saladViewModel = SaladViewModel(counterManager: counterManager, fruitSalad: fruitSalad)
        saladController.viewModel = saladViewModel
        return saladController
    }
    
    static func createOrderListModule() -> OrderListViewController {
        let orderListViewController = OrderListViewController()
        let orderListViewModel = OrderListViewModel()
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
        let orderCompleteViewModel = OrderCompleteViewModel()
        orderCompleteViewController.viewModel = orderCompleteViewModel
        return orderCompleteViewController
    }
}
