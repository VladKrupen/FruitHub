//
//  BasketView.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class Basket: UIView {
    
    var badgeCount: Int = 0 {
        didSet {
            setBadgeCount(count: badgeCount)
        }
    }
    
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
    
    private let badgeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let badgeView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 8
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVStack()
        setupBadge()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBadgeCount(count: Int) {
        badgeView.isHidden = count == 0
        badgeLabel.text = String(count)
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
    
    private func setupBadge() {
        addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 25),
            badgeLabel.topAnchor.constraint(equalTo: badgeView.topAnchor, constant: 1),
            badgeLabel.bottomAnchor.constraint(equalTo: badgeView.bottomAnchor, constant: -1),
            badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 5),
            badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -5),
            
            badgeView.bottomAnchor.constraint(equalTo: vStack.topAnchor),
            badgeView.leadingAnchor.constraint(equalTo: vStack.centerXAnchor)
        ])
    }
}
