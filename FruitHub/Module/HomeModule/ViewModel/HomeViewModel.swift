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
    
    func cellWasPressed(fruitSalad: FruitSalad)
    func basketViewWasPressed()
    func menuButtonWasPressed()
    func viewDidLoaded()
    func fetchFruitSalads()
    func updateFavoritStateForFruitSalad(fruitSalad: FruitSalad)
}

final class HomeViewModel: HomeViewModelProtocol {
    var completionHandler: ((HomeActions, FruitSalad?) -> Void)?
    
    private var orderList: [FruitSalad] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var fetchCancellable: AnyCancellable?
    private var updateCancellable: AnyCancellable?
    var fruitSaladPublisher: PassthroughSubject<[FruitSalad], Never> = .init()
    var userPublisher: PassthroughSubject<User, Never>
    var completionPublisher: PassthroughSubject<Result<Void, Error>, Never> = .init()
    
    private let firebaseManager: FirebaseManagerProtocol
    private let coreDataReceivingUser: CoreDataReceivingUser
    private let coreDataFruitSalads: CoreDataFruitSalads
    private let coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad
    
    init(firebaseManager: FirebaseManagerProtocol, coreDataReceivingUser: CoreDataReceivingUser, coreDataFruitSalads: CoreDataFruitSalads, coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad, userPublisher: PassthroughSubject<User, Never>) {
        self.firebaseManager = firebaseManager
        self.coreDataReceivingUser = coreDataReceivingUser
        self.coreDataFruitSalads = coreDataFruitSalads
        self.coreDataUpdatingFruitSalad = coreDataUpdatingFruitSalad
        self.userPublisher = userPublisher
    }

    func cellWasPressed(fruitSalad: FruitSalad) {
        completionHandler?(.saladCellPressed, fruitSalad)
    }
    
    func basketViewWasPressed() {
        guard !orderList.isEmpty else {
            completionPublisher.send(.failure(BasketError.emptyBasketError))
            return
        }
        completionHandler?(.basketPressed, nil)
    }
    
    func menuButtonWasPressed() {
        completionHandler?(.menuPressed, nil)
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
    
    func fetchFruitSalads() {
        fetchCancellable = coreDataFruitSalads.fetchFruitSalads()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.completionPublisher.send(.failure(error))
                }
            } receiveValue: { [weak self] fruitSalads in
                self?.fruitSaladPublisher.send(fruitSalads)
                self?.orderList = fruitSalads.filter { $0.isBasket == true }
            }
    }
    
    func updateFavoritStateForFruitSalad(fruitSalad: FruitSalad) {
        updateCancellable = coreDataUpdatingFruitSalad.updateFruitSalad(fruitSalad: fruitSalad)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.completionPublisher.send(.failure(error))
                }
            }, receiveValue: {
                return
            })
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
