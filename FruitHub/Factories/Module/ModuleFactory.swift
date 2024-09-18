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
}
