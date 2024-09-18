//
//  ScreenTransition.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import Foundation

protocol ScreenTransition: AnyObject {
    var completionHandler: (() -> Void)? { get set }
    func goToNextScreen()
}
