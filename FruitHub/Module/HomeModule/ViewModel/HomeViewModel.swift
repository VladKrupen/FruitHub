//
//  HomeViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var completionHandler: ((HomeActions) -> Void)? { get set }
    var fruitSaladPublisher: PassthroughSubject<Result<[FruitSalad], Error>, Never> { get set }
    func goToSaladModule()
    func goToOrderListModule()
    func getAllFruitSalads()
}

final class HomeViewModel: HomeViewModelProtocol {
    var completionHandler: ((HomeActions) -> Void)?
    
    private var cancellableFirebase: AnyCancellable?
    var fruitSaladPublisher: PassthroughSubject<Result<[FruitSalad], Error>, Never> = .init()
    
    private let firebaseManager: FirebaseManagerProtocol
    
    init(firebaseManager: FirebaseManagerProtocol) {
        self.firebaseManager = firebaseManager
    }

    func goToSaladModule() {
        completionHandler?(.saladCellPressed)
    }
    
    func goToOrderListModule() {
        completionHandler?(.basketPressed)
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
