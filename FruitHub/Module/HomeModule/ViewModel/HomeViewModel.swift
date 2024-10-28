//
//  HomeViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var completionHandler: ((HomeActions, FruitSalad?) -> Void)? { get set }
    var fruitSaladPublisher: PassthroughSubject<[FruitSalad], Never> { get set }
    var userPublisher: PassthroughSubject<User, Never> { get set }
    var completionPublisher: PassthroughSubject<Result<Void, Error>, Never> { get set }
    
    func goToSaladModule(fruitSalad: FruitSalad)
    func goToOrderListModule()
    func viewDidLoaded()
}

final class HomeViewModel: HomeViewModelProtocol {
    var completionHandler: ((HomeActions, FruitSalad?) -> Void)?
    
    private var cancellable: AnyCancellable?
    var fruitSaladPublisher: PassthroughSubject<[FruitSalad], Never> = .init()
    var userPublisher: PassthroughSubject<User, Never> = .init()
    var completionPublisher: PassthroughSubject<Result<Void, any Error>, Never> = .init()
    
    private let firebaseManager: FirebaseManagerProtocol
    private let coreDataReceivingUser: CoreDataReceivingUser
    
    init(firebaseManager: FirebaseManagerProtocol, coreDataReceivingUser: CoreDataReceivingUser) {
        self.firebaseManager = firebaseManager
        self.coreDataReceivingUser = coreDataReceivingUser
    }

    func goToSaladModule(fruitSalad: FruitSalad) {
        completionHandler?(.saladCellPressed, fruitSalad)
    }
    
    func goToOrderListModule() {
        completionHandler?(.basketPressed, nil)
    }
    
    func viewDidLoaded() {
        let firebasePublisher = firebaseManager.getAllFruitsSalad()
        let coreDataPublisher = coreDataReceivingUser.readUser()
        cancellable = Publishers.Zip(firebasePublisher, coreDataPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.completionPublisher.send(.success(()))
                case .failure(let error):
                    self?.completionPublisher.send(.failure(error))
                }
            }, receiveValue: { [weak self] fruitSalads, user in
                self?.fruitSaladPublisher.send(fruitSalads)
                self?.userPublisher.send(user)
            })
    }
}
