//
//  OrderListViewModel.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import Foundation

protocol OrderListViewModelProtocol: AnyObject {
    var completionHandler: (() -> Void)? { get set }
    
    func goToCompleteDetailsModule()
}

final class OrderListViewModel: OrderListViewModelProtocol {
    var completionHandler: (() -> Void)?
    
    func goToCompleteDetailsModule() {
        completionHandler?()
    }
}
