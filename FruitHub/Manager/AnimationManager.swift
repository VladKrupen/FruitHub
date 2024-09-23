//
//  AnimationManager.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class AnimationManager {
    static func animateClick(view: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
                completion()
            }
        }
    }
}
