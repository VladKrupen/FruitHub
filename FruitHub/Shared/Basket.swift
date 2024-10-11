//
//  BasketView.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class Basket: UIView {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        $0.image = UIImage(systemName: SystemImages.basketView)
        $0.tintColor = UIColor(hex: Colors.orange)
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.titleBasketView
        $0.font = UIFont.systemFont(ofSize: 8)
        return $0
    }(UILabel())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVStack() {
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
        ])
    }
}
