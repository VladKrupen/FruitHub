//
//  SaladViewModel.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import Foundation
import Combine

protocol SaladViewModelProtocol: AnyObject {
    var counterPublisher: PassthroughSubject<Int, Never> { get set }
    var fruitSaladPublisher: PassthroughSubject<FruitSalad, Never> { get set }
    func viewDidLoaded()
    func decreaseButtonWasPressed()
    func increaseButtonWasPressed()
}

final class SaladViewModel: SaladViewModelProtocol {
    
    var counterPublisher: PassthroughSubject<Int, Never> = .init()
    var fruitSaladPublisher: PassthroughSubject<FruitSalad, Never> = .init()
    
    private let counterManager: CounterManager
    private let fruitSalad: FruitSalad
    
    init(counterManager: CounterManager, fruitSalad: FruitSalad) {
        self.counterManager = counterManager
        self.fruitSalad = fruitSalad
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
    
    private func sendCounter() {
        counterPublisher.send(counterManager.counter)
    }
    
    private func sendFruitSalad() {
        fruitSaladPublisher.send(fruitSalad)
    }
}
