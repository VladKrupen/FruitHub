//
//  AppCoordinatorProtocol.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
