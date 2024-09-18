//
//  WelcomeViewModel.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import Foundation

final class WelcomeViewModel: ScreenTransition {
    var completionHandler: (() -> Void)?
    
    func goToNextScreen() {
        completionHandler?()
    }
}
