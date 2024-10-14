//
//  CompleteDetailsViewModel.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import Foundation

protocol CompleteDetailsViewModelProtocol: AnyObject {
    var completionHandler: ((CompleteDetailsActions) -> Void)? { get set }
    func dismissButtonWasPressed()
    func payWithCardButtonWasPressed()
    func payOnDeliveryButtonWasPressed()
}

final class CompleteDetailsViewModel: CompleteDetailsViewModelProtocol {
    var completionHandler: ((CompleteDetailsActions) -> Void)?
    
    func dismissButtonWasPressed() {
        completionHandler?(.dismissButton)
    }
    
    func payWithCardButtonWasPressed() {
        completionHandler?(.payWithCardButton)
    }
    
    func payOnDeliveryButtonWasPressed() {
        completionHandler?(.payOnDeliveryButton)
    }
}
