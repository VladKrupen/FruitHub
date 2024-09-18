//
//  SplashViewModel.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import Foundation

final class SplashViewModel: ScreenTransition {
    var completionHandler: (() -> Void)?
    
    func goToNextScreen() {
        completionHandler?()
    }
}
