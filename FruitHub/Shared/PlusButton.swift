//
//  PlusButton.swift
//  FruitHub
//
//  Created by Vlad on 25.09.24.
//

import UIKit

final class PlusButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        let backgroundImage = UIImage(systemName: SystemImages.backgroundImageForPlusButton)?
            .withTintColor(UIColor(hex: Colors.backgroundColorForButtonPlus)!, renderingMode: .alwaysOriginal)
        self.setBackgroundImage(backgroundImage, for: .normal)
        let plusImage = UIImage(systemName: SystemImages.imageForPlusButton)?
            .withTintColor(UIColor(hex: Colors.orange)!, renderingMode: .alwaysOriginal)
        self.setImage(plusImage, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
