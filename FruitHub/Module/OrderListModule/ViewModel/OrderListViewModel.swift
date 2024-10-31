//
//  OrderListViewModel.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import Foundation
import Combine

protocol OrderListViewModelProtocol: AnyObject {
    var completionHandler: ((OrderListActions, FruitSalad?) -> Void)? { get set }
    
    var fruitSaladPublisher: PassthroughSubject<[FruitSalad], Never> { get set }
    var errorMessagePublisher: PassthroughSubject<String, Never> { get set }
    var totalAmountPublisher: PassthroughSubject<Float, Never> { get set }
    
    func fetchOrderList()
    func backButtonWasPressed()
    func checkoutButtonWasPressed()
    func cellWasPressed(fruitSalad: FruitSalad)
    func removeFruidSaladFromBasket(fruitSalad: FruitSalad)
    func updateTotalAmount(orderList: [FruitSalad])
}

final class OrderListViewModel: OrderListViewModelProtocol {
    var completionHandler: ((OrderListActions, FruitSalad?) -> Void)?
    
    var fruitSaladPublisher: PassthroughSubject<[FruitSalad], Never> = .init()
    var errorMessagePublisher: PassthroughSubject<String, Never> = .init()
    var totalAmountPublisher: PassthroughSubject<Float, Never> = .init()
    
    private var fetchCancellable: AnyCancellable?
    private var updateCancellable: AnyCancellable?
    
    private let coreDataReceivingOrderList: CoreDataReceivingOrderList
    private let coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad
    
    init(coreDataReceivingOrderList: CoreDataReceivingOrderList, coreDataUpdatingFruitSalad: CoreDataUpdatingFruitSalad) {
        self.coreDataReceivingOrderList = coreDataReceivingOrderList
        self.coreDataUpdatingFruitSalad = coreDataUpdatingFruitSalad
    }
    
    func fetchOrderList() {
        fetchCancellable = coreDataReceivingOrderList.fetchOrderList()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] fruitSalads in
                self?.fruitSaladPublisher.send(fruitSalads)
                self?.calculateTotalOrderAmount(orderList: fruitSalads)
            })
    }
    
    func removeFruidSaladFromBasket(fruitSalad: FruitSalad) {
        var updatedFruitSalad: FruitSalad = fruitSalad
        updatedFruitSalad.isBasket = false
        updatedFruitSalad.packaging = 1
        updateCancellable = coreDataUpdatingFruitSalad.updateFruitSalad(fruitSalad: updatedFruitSalad)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.errorMessagePublisher.send(error.localizedDescription)
                }
            }, receiveValue: {
                return
            })
    }
    
    func updateTotalAmount(orderList: [FruitSalad]) {
        calculateTotalOrderAmount(orderList: orderList)
    }
    
    func backButtonWasPressed() {
        completionHandler?(.backButtonPressed, nil)
    }
    
    func checkoutButtonWasPressed() {
        completionHandler?(.checkoutButtonPressed, nil)
    }
    
    func cellWasPressed(fruitSalad: FruitSalad) {
        completionHandler?(.cellPressed, fruitSalad)
    }
}

//MARK: Calculate
extension OrderListViewModel {
    private func calculateTotalOrderAmount(orderList: [FruitSalad]) {
        var totalAmount: Float = 0
        orderList.forEach { totalAmount += $0.price * Float($0.packaging) }
        totalAmountPublisher.send(totalAmount)
    }
}
