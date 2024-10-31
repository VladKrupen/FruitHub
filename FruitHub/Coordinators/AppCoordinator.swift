//
//  AppCoordinator.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class AppCoordinator: AppCoordinatorProtocol {
    
    var navigationController: UINavigationController
    private var childCoordinator: [CoordinatorProtocol] = []
    
    private let appLaunchChecking: AppLaunchChecking
    private let appLaunchSetting: AppLaunchSetting
    
    init(navigationController: UINavigationController, appLaunchChecking: AppLaunchChecking, appLaunchSetting: AppLaunchSetting) {
        self.navigationController = navigationController
        self.appLaunchChecking = appLaunchChecking
        self.appLaunchSetting = appLaunchSetting
    }
    
    func start() {
        showSplashFlow()
    }
    
    private func showSplashFlow() {
        let splashCoordinator = CoordinatorFactory.createSplashCoordinator(navigationController: navigationController)
        childCoordinator.append(splashCoordinator)
        splashCoordinator.start()
        splashCoordinator.flowCompletionHandler = { [weak self] in
            guard let self else { return }
            self.childCoordinator.removeAll()
            guard appLaunchChecking.isNotFirstAppLaunch() else {
                self.showWelcomeFlow()
                return
            }
            self.showHomeFlow()
        }
    }
    
    private func showWelcomeFlow() {
        let welcomeCoordinator = CoordinatorFactory.createWelcomeCoordinator(navigationController: navigationController)
        childCoordinator.append(welcomeCoordinator)
        welcomeCoordinator.start()
        welcomeCoordinator.flowCompletionHandler = { [weak self] in
            self?.childCoordinator.removeAll()
            self?.showEnterNameFlow()
        }
    }
    
    private func showEnterNameFlow() {
        let enterNameCoordinator = CoordinatorFactory.createEnterNameCoordinator(navigationController: navigationController)
        childCoordinator.append(enterNameCoordinator)
        enterNameCoordinator.start()
        enterNameCoordinator.flowCompletionHandler = { [weak self] in
            self?.childCoordinator.removeAll()
            self?.showHomeFlow()
            self?.appLaunchSetting.setFirstAppLaunch()
        }
    }
    
    private func showHomeFlow() {
        let homeCoordinator = CoordinatorFactory.createHomeCoordiantor(navigationController: navigationController)
        childCoordinator.append(homeCoordinator)
        homeCoordinator.start()
        homeCoordinator.flowCompletionHandler = { [weak self] in
            self?.childCoordinator.removeAll()
        }
    }
}
