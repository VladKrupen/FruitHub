//
//  CardDataVerificationError.swift
//  FruitHub
//
//  Created by Vlad on 15.10.24.
//

import Foundation

enum CardDataVerificationError: Error {
    case emptyCarData
    case invalidCardHolderName
    case invalidCardNumber
    case invalidCardDate
    case invalidCardCvv
}
