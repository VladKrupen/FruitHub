//
//  DataVerificationManager.swift
//  FruitHub
//
//  Created by Vlad on 15.10.24.
//

import Foundation

protocol UserDataVerification {
    func validateUserData(user: User, completion: (Result<User, UserVerificationError>) -> Void)
}

protocol DeliveryDataVerification {
    func validateDeliveryData(deliveryData: DeliveryData, completion: (Result<DeliveryData, DeliveryDataVerificationError>) -> Void)
}

protocol CardDataVerification {
    func validateCardData(cardData: CardData, completion: (Result<CardData, CardDataVerificationError>) -> Void)
}

final class DataVerificationManager {
    
    private func isNonEmptyName(user: User) -> Bool {
        guard !user.name.isEmpty else {
            return false
        }
        return true
    }
    
    private func isNonEmptyDeliveryData(deliveryData: DeliveryData) -> Bool {
        guard !deliveryData.address.isEmpty && !deliveryData.numberPhone.isEmpty else {
            return false
        }
        return true
    }
    
    private func isCorrectNumberPhone(deliveryData: DeliveryData) -> Bool {
        guard deliveryData.numberPhone.count == 11 else {
            return false
        }
        return true
    }
    
    private func isNonEmptyCardData(cardData: CardData) -> Bool {
        guard !cardData.cardHoldersName.isEmpty,
              !cardData.cardNumber.isEmpty,
              !cardData.cardDate.isEmpty,
              !cardData.cardCVV.isEmpty else {
            return false
        }
        return true
    }
    
    private func isValidCardHoldersNameFormat(cardData: CardData) -> Bool {
        let names = cardData.cardHoldersName.components(separatedBy: " ")
        guard names.count == 2 else {
            return false
        }
        return true
    }
    
    private func isValidCardNumberFormat(cardData: CardData) -> Bool {
        guard cardData.cardNumber.count == 16 else {
            return false
        }
        return true
    }
    
    private func isValidDateFormat(cardData: CardData) -> Bool {
        let regex = #"^(0[1-9]|1[0-2])\/\d{2}$"#
        guard cardData.cardDate.range(of: regex, options: .regularExpression) != nil else {
            return false
        }
        return true
    }
    
    private func isValidCardCvvFormat(cardData: CardData) -> Bool {
        guard cardData.cardCVV.count == 3 else {
            return false
        }
        return true
    }
}

//MARK: UserDataVerification
extension DataVerificationManager: UserDataVerification {
    func validateUserData(user: User, completion: (Result<User, UserVerificationError>) -> Void) {
        guard isNonEmptyName(user: user) else {
            completion(.failure(.emptyName))
            return
        }
        completion(.success(user))
    }
}

//MARK: DeliveryDataVerification
extension DataVerificationManager: DeliveryDataVerification {
    func validateDeliveryData(deliveryData: DeliveryData, completion: (Result<DeliveryData, DeliveryDataVerificationError>) -> Void) {
        guard isNonEmptyDeliveryData(deliveryData: deliveryData) else {
            completion(.failure(.emptyDeliveryData))
            return
        }
        guard isCorrectNumberPhone(deliveryData: deliveryData) else {
            completion(.failure(.wrongNumber))
            return
        }
        completion(.success(deliveryData))
    }
}

//MARK: CardDataVerification
extension DataVerificationManager: CardDataVerification {
    func validateCardData(cardData: CardData, completion: (Result<CardData, CardDataVerificationError>) -> Void) {
        guard isNonEmptyCardData(cardData: cardData) else {
            completion(.failure(.emptyCarData))
            return
        }
        guard isValidCardHoldersNameFormat(cardData: cardData) else {
            completion(.failure(.invalidCardHolderName))
            return
        }
        guard isValidCardNumberFormat(cardData: cardData) else {
            completion(.failure(.invalidCardNumber))
            return
        }
        guard isValidDateFormat(cardData: cardData) else {
            completion(.failure(.invalidCardDate))
            return
        }
        guard isValidCardCvvFormat(cardData: cardData) else {
            completion(.failure(.invalidCardCvv))
            return
        }
        completion(.success(cardData))
    }
}
