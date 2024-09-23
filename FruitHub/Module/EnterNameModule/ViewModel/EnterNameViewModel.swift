//
//  EnterNameViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation

protocol EnterNameViewModelProtocol: ScreenTransition {

}

final class EnterNameViewModel: EnterNameViewModelProtocol {
    
    var completionHandler: (() -> Void)?
    
    func goToNextScreen() {
        completionHandler?()
    }
}
