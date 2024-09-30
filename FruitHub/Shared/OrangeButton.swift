//
//  OrangeButton.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class OrangeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor(hex: Colors.orange)
        self.layer.cornerRadius = 10
    }
}
