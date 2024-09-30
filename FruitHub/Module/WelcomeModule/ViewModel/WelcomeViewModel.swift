//
//  WelcomeViewModel.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import Foundation

protocol WelcomeViewModelProtocol: ScreenTransition {
    func goToNextScreen()
}

final class WelcomeViewModel: WelcomeViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    func goToNextScreen() {
        completionHandler?()
    }
}
