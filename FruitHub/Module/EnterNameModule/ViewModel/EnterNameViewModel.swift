//
//  EnterNameViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation
import Combine

protocol EnterNameViewModelProtocol: ScreenTransition, AnyObject {
    var errorMessagePublisher: PassthroughSubject<String, Never> { get set }
    func startOrderingButtonWasPressed(user: User)
}

final class EnterNameViewModel: EnterNameViewModelProtocol {
        
    var errorMessagePublisher: PassthroughSubject<String, Never> = PassthroughSubject()
    var completionHandler: (() -> Void)?
    
    private var cancellable: AnyCancellable?
    
    private let userDataVerification: UserDataVerification
    private let coreDataCreationUser: CoreDataCreationUser
  
    init(userDataVerification: UserDataVerification, coreDataCreationUser: CoreDataCreationUser) {
        self.userDataVerification = userDataVerification
        self.coreDataCreationUser = coreDataCreationUser
    }
    
    func startOrderingButtonWasPressed(user: User) {
        userDataVerification.validateUserData(user: user) { [weak self] results in
            switch results {
            case .success(_):
                self?.createUser(user: user)
            case .failure(let error):
                self?.handleErrors(error: error)
            }
        }
    }
    
    private func createUser(user: User) {
        cancellable = coreDataCreationUser.createUser(user: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] in
                self?.goToNextScreen()
            })
    }
    
    private func goToNextScreen() {
        completionHandler?()
    }
    
    private func handleErrors(error: UserVerificationError) {
        switch error {
        case .emptyName:
            errorMessagePublisher.send(AlertMessage.nameEmpty)
        }
    }
}
