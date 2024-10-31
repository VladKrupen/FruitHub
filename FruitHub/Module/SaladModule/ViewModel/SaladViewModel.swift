//
//  SaladViewModel.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import Foundation
import Combine

protocol SaladViewModelProtocol: AnyObject {
    var completionHandler: (() -> Void)? { get set }
    
    var counterPublisher: PassthroughSubject<Int, Never> { get set }
    var fruitSaladPublisher: PassthroughSubject<FruitSalad, Never> { get set }
    var errorMessagePublisher: PassthroughSubject<String, Never> { get set }
    
    func viewDidLoaded()
    func decreaseButtonWasPressed()
    func increaseButtonWasPressed()
    func addToBasketButtonWasPressed(favorite: Bool)
    func handleCompletion()
    func favoriteButtonWasPressed(favorite: Bool)
}

final class SaladViewModel: SaladViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    var counterPublisher: PassthroughSubject<Int, Never> = .init()
    var fruitSaladPublisher: PassthroughSubject<FruitSalad, Never> = .init()
    var errorMessagePublisher: PassthroughSubject<String, Never> = .init()
    private var cancellable: AnyCancellable?
    
    private var fruitSalad: FruitSalad
    
    private let counterManager: CounterManager
    private let coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad
    
    init(counterManager: CounterManager, fruitSalad: FruitSalad, coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad) {
        self.counterManager = counterManager
        self.fruitSalad = fruitSalad
        self.coreDataUpdatingFruitSalad = coreDataUpdatingFruitSalad
    }
    
    func viewDidLoaded() {
        sendCounter()
        sendFruitSalad()
    }
    
    func decreaseButtonWasPressed() {
        counterManager.decreaseCounter()
        sendCounter()
    }
    
    func increaseButtonWasPressed() {
        counterManager.increaseCounter()
        sendCounter()
    }
    
    func addToBasketButtonWasPressed(favorite: Bool) {
        updateFruitSalad(favorite: favorite)
        cancellable = coreDataUpdatingFruitSalad.updateFruitSalad(fruitSalad: fruitSalad)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            } receiveValue: { [weak self] in
                self?.handleCompletion()
            }
    }
    
    func favoriteButtonWasPressed(favorite: Bool) {
        fruitSalad.isFavorite = favorite
        cancellable = coreDataUpdatingFruitSalad.updateFruitSalad(fruitSalad: fruitSalad)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            }, receiveValue: {
                return
            })
    }
    
    func handleCompletion() {
        completionHandler?()
    }
    
    private func updateFruitSalad(favorite: Bool) {
        fruitSalad.isFavorite = favorite
        fruitSalad.packaging = counterManager.counter
        fruitSalad.isBasket = true
    }
    
    private func sendCounter() {
        counterPublisher.send(counterManager.counter)
    }
    
    private func sendFruitSalad() {
        fruitSaladPublisher.send(fruitSalad)
    }
}
