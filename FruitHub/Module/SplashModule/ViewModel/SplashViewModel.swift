//
//  SplashViewModel.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import Foundation

protocol SplashViewModelProtocol: ScreenTransition, AnyObject {
    func goToNextScreen()
}

final class SplashViewModel: SplashViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    func goToNextScreen() {
        completionHandler?()
    }
}
