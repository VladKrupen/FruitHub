//
//  HomeViewModel.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var completionHandler: ((HomeActions) -> Void)? { get set }
    func goToSaladModule()
}

final class HomeViewModel: HomeViewModelProtocol {
    var completionHandler: ((HomeActions) -> Void)?

    func goToSaladModule() {
        completionHandler?(.saladCellPressed)
    }
}
