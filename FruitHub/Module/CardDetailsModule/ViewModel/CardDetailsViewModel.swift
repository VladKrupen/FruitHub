//
//  CardDetailsViewModel.swift
//  FruitHub
//
//  Created by Vlad on 13.10.24.
//

import Foundation

protocol CardDetailsViewModelProtocol: AnyObject {
    var completionHandler: ((CardDetailsActions) -> Void)? { get set }
    func dismissButtonWasPressed()
    func completeOrderButtonWasPressed()
}

final class CardDetailsViewModel: CardDetailsViewModelProtocol {
    var completionHandler: ((CardDetailsActions) -> Void)?
    
    func dismissButtonWasPressed() {
        completionHandler?(.dismissButton)
    }
    
    func completeOrderButtonWasPressed() {
        completionHandler?(.completeOrderButton)
    }
}
