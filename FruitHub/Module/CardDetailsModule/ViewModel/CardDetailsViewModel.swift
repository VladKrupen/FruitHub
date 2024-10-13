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
}

final class CardDetailsViewModel: CardDetailsViewModelProtocol {
    var completionHandler: ((CardDetailsActions) -> Void)?
    
    func dismissButtonWasPressed() {
        completionHandler?(.dismissButton)
    }
}
