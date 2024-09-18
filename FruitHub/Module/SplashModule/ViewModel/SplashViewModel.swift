//
//  SplashViewModel.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import Foundation

protocol SplashViewModelProtocol {
    var completionHandler: (() -> Void)? { get set }
    func goToNextScreen()
}

final class SplashViewModel: SplashViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    func goToNextScreen() {
        completionHandler?()
    }
}
