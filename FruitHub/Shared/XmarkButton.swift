//
//  XmarkButton.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit

final class XmarkButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let backgroundImage = UIImage(systemName: SystemImages.backgroundImageCircleFill)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        self.setBackgroundImage(backgroundImage, for: .normal)
        let multiplyImage = UIImage(systemName: SystemImages.multiply)?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        self.setImage(multiplyImage, for: .normal)
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

