//
//  OrangeButton.swift
//  FruitHub
//
//  Created by Vlad on 12.10.24.
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
        self.setTitleColor(UIColor(hex: Colors.orange), for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: Colors.orange)?.cgColor
    }
}
