//
//  OrderCompleteViewModel.swift
//  FruitHub
//
//  Created by Vlad on 14.10.24.
//

import Foundation
import Combine

protocol OrderCompleteViewModelProtocol: AnyObject {
    var completionHandler: (() -> Void)? { get set }
    
    var errorMessagePublisher: PassthroughSubject<String, Never> { get set }
    
    func viewDidLoaded()
    func greatButtonWasPressed()
}

final class OrderCompleteViewModel: OrderCompleteViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    var errorMessagePublisher: PassthroughSubject<String, Never> = .init()
    private var cancellables: Set<AnyCancellable> = []
    
    private let coreDataReceivingOrderList: CoreDataReceivingOrderList
    private let coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad
    
    init(coreDataReceivingOrderList: CoreDataReceivingOrderList, coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad) {
        self.coreDataReceivingOrderList = coreDataReceivingOrderList
        self.coreDataUpdatingFruitSalad = coreDataUpdatingFruitSalad
    }
    
    func viewDidLoaded() {
        coreDataReceivingOrderList.fetchOrderList()
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                self?.errorMessagePublisher.send(error.localizedDescription)
            }
            } receiveValue: { [weak self] orderList in
                self?.updateOrderList(orderList: orderList)
            }
            .store(in: &cancellables)
    }
    
    func greatButtonWasPressed() {
        completionHandler?()
    }
    
    private func updateOrderList(orderList: [FruitSalad]) {
        var messageError: String?
        for order in orderList {
            var fruitSalad = order
            fruitSalad.packaging = 1
            fruitSalad.isBasket = false
            coreDataUpdatingFruitSalad.updateFruitSalad(fruitSalad: fruitSalad)
                .sink { completion in
                    switch completion {
                    case .finished:
                        return
                    case .failure(let error):
                        messageError = error.localizedDescription
                    }
                } receiveValue: {
                    return
                }
                .store(in: &cancellables)
        }
        guard let messageError else { return }
        errorMessagePublisher.send(messageError)
    }
}
