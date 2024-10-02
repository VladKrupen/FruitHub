//
//  CounterManager.swift
//  FruitHub
//
//  Created by Vlad on 2.10.24.
//

import Foundation

final class CounterManager {
    
    var counter: Int = 1
    
    func increaseCounter() {
        counter += 1
    }
    
    func decreaseCounter() {
        counter -= 1
    }
}
