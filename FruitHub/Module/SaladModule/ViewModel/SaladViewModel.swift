//
//  SaladViewModel.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import Foundation
import Combine

protocol SaladViewModelProtocol {
    var counter: PassthroughSubject<Int, Never> { get set }
    func viewDidLoaded()
    func decreaseButtonWasPressed()
    func increaseButtonWasPressed()
}

final class SaladViewModel: SaladViewModelProtocol {
    
    var counter: PassthroughSubject<Int, Never> = PassthroughSubject<Int, Never>()
    
    private let counterManager: CounterManager
    
    init(counterManager: CounterManager) {
        self.counterManager = counterManager
    }
    
    func viewDidLoaded() {
        sendCounter()
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
        counter.send(counterManager.counter)
    }
}
