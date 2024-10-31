//
//  OrderCompleteViewModel.swift
//  FruitHub
//
//  Created by Vlad on 14.10.24.
//

import Foundation

protocol OrderCompleteViewModelProtocol: AnyObject {
    var completionHandler: (() -> Void)? { get set }
    
    func greatButtonWasPressed()
}

final class OrderCompleteViewModel: OrderCompleteViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    func greatButtonWasPressed() {
        completionHandler?()
    }
}
