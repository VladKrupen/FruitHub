//
//  FavoriteButton.swift
//  FruitHub
//
//  Created by Vlad on 25.09.24.
//

import UIKit

final class FavoriteButton: UIButton {
    
    var isFavorite: Bool? {
        willSet {
            guard let value = newValue else { return }
            let heartFill = UIImage(systemName: SystemImages.heartFill)?
                .withTintColor(UIColor(hex: Colors.orange)!, renderingMode: .alwaysOriginal)
            let heart = UIImage(systemName: SystemImages.heart)?
                .withTintColor(UIColor(hex: Colors.orange)!, renderingMode: .alwaysOriginal)
            value ? setImage(heartFill, for: .normal) : setImage(heart, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
