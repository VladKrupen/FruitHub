//
//  SceneDelegate.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appCoordinator = CoordinatorFactory.createAppCoordinator(navigationController: UINavigationController())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appCoordinator.navigationController
        appCoordinator.start()
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        self.window = window
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        window?.rootViewController?.view.endEditing(true)
        window?.rootViewController?.presentedViewController?.view.endEditing(true)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        let coreDataSaving: CoreDataSaving = CoreDataManager()
        do {
            try coreDataSaving.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
}

