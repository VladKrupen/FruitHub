//
//  CounterChange.swift
//  FruitHub
//
//  Created by Vlad on 1.10.24.
//

import UIKit

final class CounterChange: UIView {
    
    var isActive: Bool? {
        willSet {
            guard let value = newValue else { return }
            value ? makeActive() : makeInactive()
        }
    }
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),
            widthAnchor.constraint(equalToConstant: 40),
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(string: String) {
        imageView.image = UIImage(systemName: string)?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
    }
    
    private func makeActive() {
        self.layer.opacity = 1
        self.isUserInteractionEnabled = true
    }
    
    private func makeInactive() {
        self.layer.opacity = 0.3
        self.isUserInteractionEnabled = false
    }
}
