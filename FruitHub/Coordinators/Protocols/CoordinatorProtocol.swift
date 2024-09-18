//
//  CoordinatorProtocol.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    var flowCompletionHandler: (() -> Void)? { get set }
    func start()
}
