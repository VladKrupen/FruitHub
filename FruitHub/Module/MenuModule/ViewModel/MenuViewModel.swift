//
//  MenuViewModel.swift
//  FruitHub
//
//  Created by Vlad on 1.11.24.
//

import Foundation
import Combine

protocol MenuViewModelProtocol: AnyObject {
    var completionHandler: (() -> Void)? { get set }
    
    var errorMessagePublisher: PassthroughSubject<String, Never> { get set }
    var userPublisher: PassthroughSubject<User, Never> { get set }
    
    func viewDidLoaded()
    func dismissButtonWasPressed()
    func updateName(name: String)
}

final class MenuViewModel: MenuViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    var errorMessagePublisher: PassthroughSubject<String, Never> = .init()
    var userPublisher: PassthroughSubject<User, Never>
    private var fetchCancellable: AnyCancellable?
    private var updatingCancellable: AnyCancellable?
    
    private let coreDataUpdatingUser: CoreDataUpdatingUser
    private let coreDataReceivingUser: CoreDataReceivingUser
    
    init(coreDataUpdatingUser: CoreDataUpdatingUser, coreDataReceivingUser: CoreDataReceivingUser, userPublisher: PassthroughSubject<User, Never>) {
        self.coreDataUpdatingUser = coreDataUpdatingUser
        self.coreDataReceivingUser = coreDataReceivingUser
        self.userPublisher = userPublisher
    }
    
    func viewDidLoaded() {
        fetchCancellable = coreDataReceivingUser.fetchUser()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] user in
                self?.userPublisher.send(user)
            })
    }
    
    func dismissButtonWasPressed() {
        completionHandler?()
    }
    
    func updateName(name: String) {
        let user = User(name: name)
        updatingCancellable = coreDataUpdatingUser.updateUser(user: user)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] in
                self?.userPublisher.send(user)
            })
    }
}
