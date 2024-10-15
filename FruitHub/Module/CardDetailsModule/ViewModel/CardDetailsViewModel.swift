//
//  CardDetailsViewModel.swift
//  FruitHub
//
//  Created by Vlad on 13.10.24.
//

import Foundation
import Combine

protocol CardDetailsViewModelProtocol: AnyObject {
    var completionHandler: ((CardDetailsActions) -> Void)? { get set }
    var cardDataErrorMessage: PassthroughSubject<String, Never> { get set }
    func dismissButtonWasPressed()
    func completeOrderButtonWasPressed(cardData: CardData)
}

final class CardDetailsViewModel: CardDetailsViewModelProtocol {
    var completionHandler: ((CardDetailsActions) -> Void)?
    
    var cardDataErrorMessage: PassthroughSubject<String, Never> = PassthroughSubject()
    
    private let cardDataVerification: CardDataVerification
    
    init(cardDataVerification: CardDataVerification) {
        self.cardDataVerification = cardDataVerification
    }
    
    func dismissButtonWasPressed() {
        completionHandler?(.dismissButton)
    }
    
    func completeOrderButtonWasPressed(cardData: CardData) {
        cardDataVerification.validateCardData(cardData: cardData) { [weak self] results in
            switch results {
            case .success(_):
                self?.completionHandler?(.completeOrderButton)
            case .failure(let error):
                self?.handleErrors(error: error)
            }
        }
    }
    
    private func handleErrors(error: CardDataVerificationError) {
        switch error {
        case .emptyCarData:
            cardDataErrorMessage.send(AlertMessage.cardDataEmpty)
        case .invalidCardHolderName:
            cardDataErrorMessage.send(AlertMessage.invalidCardHoldersName)
        case .invalidCardNumber:
            cardDataErrorMessage.send(AlertMessage.invalidCardNumber)
        case .invalidCardDate:
            cardDataErrorMessage.send(AlertMessage.invalidCardDate)
        case .invalidCardCvv:
            cardDataErrorMessage.send(AlertMessage.invalidCardCVC)
        }
    }
}
