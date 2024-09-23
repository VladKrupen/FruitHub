//
//  CustomTextField.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class CustomTextField: UITextField {
    
    private let indent: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true
        self.font = UIFont.systemFont(ofSize: 20)
        self.backgroundColor = UIColor(hex: Colors.backgroundTextField)
        self.layer.cornerRadius = 10
        self.leftView = indent
        self.leftViewMode = .always
        self.rightView = indent
        self.rightViewMode = .always
    }
}
