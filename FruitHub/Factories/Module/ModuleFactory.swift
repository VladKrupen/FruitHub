//
//  ModuleFactory.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class ModuleFactory {
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
        let enterNameViewModel = EnterNameViewModel()
        enterNameViewController.viewModel = enterNameViewModel
        return enterNameViewController
    }
    
    static func createHomeModule() -> HomeViewController {
        let homeViewController = HomeViewController()
        let homeViewModel = HomeViewModel()
        homeViewController.viewModel = homeViewModel
        return homeViewController
    }
    
    static func createSaladModule() -> SaladViewController {
        let counterManager = CounterManager()
        let saladController = SaladViewController()
        let saladViewModel = SaladViewModel(counterManager: counterManager)
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
        let completeDetailsViewModel = CompleteDetailsViewModel()
        completeDetailsViewController.viewModel = completeDetailsViewModel
        return completeDetailsViewController
    }
}
