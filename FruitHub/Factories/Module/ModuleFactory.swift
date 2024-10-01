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
        let saladController = SaladViewController()
        let saladViewModel = SaladViewModel()
        saladController.viewModel = saladViewModel
        return saladController
    }
}
