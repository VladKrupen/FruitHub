//
//  CompleteDetailsViewModel.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import Foundation
import Combine

protocol CompleteDetailsViewModelProtocol: AnyObject {
    var deliveryDataErrorMessage: PassthroughSubject<String, Never> { get set }
    var completionHandler: ((CompleteDetailsActions) -> Void)? { get set }
    func dismissButtonWasPressed()
    func payWithCardButtonWasPressed(deliveryData: DeliveryData)
    func payOnDeliveryButtonWasPressed(deliveryData: DeliveryData)
}

final class CompleteDetailsViewModel: CompleteDetailsViewModelProtocol {
    var completionHandler: ((CompleteDetailsActions) -> Void)?
    
    var deliveryDataErrorMessage: PassthroughSubject<String, Never> = PassthroughSubject()
    
    private let deliveryDataVerification: DeliveryDataVerification
    
    init(deliveryDataVerification: DeliveryDataVerification) {
        self.deliveryDataVerification = deliveryDataVerification
    }
    
    func dismissButtonWasPressed() {
        completionHandler?(.dismissButton)
    }
    
    func payWithCardButtonWasPressed(deliveryData: DeliveryData) {
        validateDelivetyData(deliveryData: deliveryData) {
            completionHandler?(.payWithCardButton)
        }
    }
    
    func payOnDeliveryButtonWasPressed(deliveryData: DeliveryData) {
        validateDelivetyData(deliveryData: deliveryData) {
            completionHandler?(.payOnDeliveryButton)
        }
    }
    
    private func validateDelivetyData(deliveryData: DeliveryData, completion: () -> Void) {
        deliveryDataVerification.validateDeliveryData(deliveryData: deliveryData) { [weak self] results in
            switch results {
            case .success(_):
                completion()
            case .failure(let error):
                self?.handleErrors(error: error)
            }
        }
    }
    
    private func handleErrors(error: DeliveryDataVerificationError) {
        switch error {
        case .emptyDeliveryData:
            deliveryDataErrorMessage.send(AlertMessage.deliveryDataEmpty)
        case .wrongNumber:
            deliveryDataErrorMessage.send(AlertMessage.deliveryDataNumberError)
        }
    }
}
