//
//  SplashView.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class SplashView: UIView {
    
    let splashImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: ImageAssets.splashImage)
        $0.layer.opacity = 0
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: Colors.whiteForSplash)
        layoutImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutImageView() {
        addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
