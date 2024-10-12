//
//  CompleteDetailsViewModel.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import Foundation

protocol CompleteDetailsViewModelProtocol: AnyObject {
    var completionHandler: ((CompleteDetailsActions) -> Void)? { get set }
    func dismissAction()
}

final class CompleteDetailsViewModel: CompleteDetailsViewModelProtocol {
    var completionHandler: ((CompleteDetailsActions) -> Void)?
    
    func dismissAction() {
        completionHandler?(.dismissButton)
    }
}
