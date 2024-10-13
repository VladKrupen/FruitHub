//
//  EnterNameViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation
import Combine

protocol EnterNameViewModelProtocol: ScreenTransition {
    var nameEmptyErrorMessage: PassthroughSubject<String, Never> { get set }
    func checkIfNameIsEmpty(name: String)
}

final class EnterNameViewModel: EnterNameViewModelProtocol {
    
    var nameEmptyErrorMessage: PassthroughSubject<String, Never> = PassthroughSubject()
    
    var completionHandler: (() -> Void)?
    
    func checkIfNameIsEmpty(name: String) {
        guard !name.isEmpty else {
            nameEmptyErrorMessage.send("Please enter your name")
            return
        }
        goToNextScreen()
    }
    
    func goToNextScreen() {
        completionHandler?()
    }
}
