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
    var fruitSaladPublisher: PassthroughSubject<Result<[FruitSalad], Error>, Never> { get set }
    func goToSaladModule(fruitSalad: FruitSalad)
    func goToOrderListModule()
    func getAllFruitSalads()
}

final class HomeViewModel: HomeViewModelProtocol {
    var completionHandler: ((HomeActions, FruitSalad?) -> Void)?
    
    private var cancellableFirebase: AnyCancellable?
    var fruitSaladPublisher: PassthroughSubject<Result<[FruitSalad], Error>, Never> = .init()
    
    private let firebaseManager: FirebaseManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol) {
        self.firebaseManager = firebaseManager
    }

    func goToSaladModule(fruitSalad: FruitSalad) {
        completionHandler?(.saladCellPressed, fruitSalad)
    }
    
    func goToOrderListModule() {
        completionHandler?(.basketPressed, nil)
    }
    
    func getAllFruitSalads() {
        cancellableFirebase = firebaseManager.getAllFruitsSalad()
            .sink { [weak self] results in
                switch results {
                case .success(let fruitSalads):
                    self?.fruitSaladPublisher.send(.success(fruitSalads))
                case .failure(let error):
                    self?.fruitSaladPublisher.send(.failure(error))
                }
            }
    }
}
