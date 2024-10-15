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
    func startOrderingButtonWasPressed(user: User)
}

final class EnterNameViewModel: EnterNameViewModelProtocol {
        
    var nameEmptyErrorMessage: PassthroughSubject<String, Never> = PassthroughSubject()
    
    var completionHandler: (() -> Void)?
    
    private let userDataVerification: UserDataVerification
  
    init(userDataVerification: UserDataVerification) {
        self.userDataVerification = userDataVerification
    }
    
    func startOrderingButtonWasPressed(user: User) {
        userDataVerification.validateUserData(user: user) { [weak self] results in
            switch results {
            case .success(_):
                self?.goToNextScreen()
            case .failure(let error):
                self?.handleErrors(error: error)
            }
        }
    }
    
    func goToNextScreen() {
        completionHandler?()
    }
    
    private func handleErrors(error: UserVerificationError) {
        switch error {
        case .emptyName:
            nameEmptyErrorMessage.send(AlertMessage.nameEmpty)
        }
    }
}
