//
//  BackButtonView.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import UIKit

final class BackButtonView: UIView {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: SystemImages.backward)
        $0.tintColor = .black
        return $0
    }(UIImageView())
    
    private let backLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Go back"
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private let hStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.layer.cornerRadius = 15
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutElements() {
        hStack.addArrangedSubview(imageView)
        hStack.addArrangedSubview(backLabel)
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
        ])
    }
}
