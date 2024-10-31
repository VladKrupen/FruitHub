//
//  HomeViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: AnyObject {
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
    
    private var cancellables: Set<AnyCancellable> = .init()
    var fruitSaladPublisher: PassthroughSubject<[FruitSalad], Never> = .init()
    var userPublisher: PassthroughSubject<User, Never> = .init()
    var completionPublisher: PassthroughSubject<Result<Void, any Error>, Never> = .init()
    
    private let firebaseManager: FirebaseManagerProtocol
    private let coreDataReceivingUser: CoreDataReceivingUser
    private let coreDataFruitSalads: CoreDataFruitSalads
    
    init(firebaseManager: FirebaseManagerProtocol, coreDataReceivingUser: CoreDataReceivingUser, coreDataFruitSalads: CoreDataFruitSalads) {
        self.firebaseManager = firebaseManager
        self.coreDataReceivingUser = coreDataReceivingUser
        self.coreDataFruitSalads = coreDataFruitSalads
    }

    func goToSaladModule(fruitSalad: FruitSalad) {
        completionHandler?(.saladCellPressed, fruitSalad)
    }
    
    func goToOrderListModule() {
        completionHandler?(.basketPressed, nil)
    }
    
    func viewDidLoaded() {
        let firebasePublisher = firebaseManager.getAllFruitSalads()
        let coreDataReceivingUserPublisher = coreDataReceivingUser.fetchUser()
        let coreDataFruitSalads = coreDataFruitSalads.fetchFruitSalads()
        Publishers.Zip3(firebasePublisher, coreDataReceivingUserPublisher, coreDataFruitSalads)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.completionPublisher.send(.failure(error))
                }
            }, receiveValue: { [weak self] fruitSaladsFB, user, fruitSaladsCD in
                guard let self = self else { return }
                self.userPublisher.send(user)
                guard self.compareFruitSalads(fruitSaladsFB: fruitSaladsFB, fruitSaladsCD: fruitSaladsCD) else {
                    self.updateFruitSaladsForCoreData(fruitSalads: fruitSaladsFB)
                    return
                }
                self.fruitSaladPublisher.send(fruitSaladsCD)
                self.completionPublisher.send(.success(()))
            })
            .store(in: &cancellables)
    }
    
    private func updateFruitSaladsForCoreData(fruitSalads: [FruitSalad]) {
        coreDataFruitSalads.removeAllFruitSalads()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.completionPublisher.send(.failure(error))
                }
            } receiveValue: { [weak self] in
                self?.createFruitSalads(fruitSalads: fruitSalads)
            }
            .store(in: &cancellables)
    }
    
    private func createFruitSalads(fruitSalads: [FruitSalad]) {
        coreDataFruitSalads.createFruitSalads(fruitSalads: fruitSalads)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.completionPublisher.send(.failure(error))
                }
            } receiveValue: { [weak self] in
                self?.fruitSaladPublisher.send(fruitSalads)
                self?.completionPublisher.send(.success(()))
            }
            .store(in: &cancellables)
    }
}

//MARK: CompareFruitSalads
extension HomeViewModel {
    private func compareFruitSalads(fruitSaladsFB: [FruitSalad], fruitSaladsCD: [FruitSalad]) -> Bool {
        let firebaseSet = Set(fruitSaladsFB.map { FruitSaladHashable(id: $0.id,
                                                                     imageUrl: $0.imageUrl,
                                                                     nameSalad: $0.nameSalad,
                                                                     price: $0.price,
                                                                     compound: $0.compound,
                                                                     description: $0.description,
                                                                     isRecommended: $0.isRecommended,
                                                                     isFruitSalad: $0.isFruitSalad,
                                                                     isExoticSalad: $0.isExoticSalad,
                                                                     isCitrusSalad: $0.isCitrusSalad,
                                                                     isSeasonSalad: $0.isSeasonSalad) })
        let coreDataSet = Set(fruitSaladsCD.map { FruitSaladHashable(id: $0.id,
                                                                     imageUrl: $0.imageUrl,
                                                                     nameSalad: $0.nameSalad,
                                                                     price: $0.price,
                                                                     compound: $0.compound,
                                                                     description: $0.description,
                                                                     isRecommended: $0.isRecommended,
                                                                     isFruitSalad: $0.isFruitSalad,
                                                                     isExoticSalad: $0.isExoticSalad,
                                                                     isCitrusSalad: $0.isCitrusSalad,
                                                                     isSeasonSalad: $0.isSeasonSalad) })
        guard firebaseSet == coreDataSet else {
            return false
        }
        return true
    }
}
