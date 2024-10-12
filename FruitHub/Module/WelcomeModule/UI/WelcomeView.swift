//
//  WelcomeView.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class WelcomeView: UIView {
    
    //MARK: UI
    private let whiteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: Colors.white)
        return $0
    }(UIView())
    
    private let fruitImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: ImageAssets.welcomeFruit)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.titleForWelcomeModule
        $0.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.descriptionForWelcomeModule
        $0.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        $0.attributedText = NSAttributedString(string: $0.text ?? "", attributes: attributes)
        $0.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        return $0
    }(UILabel())
    
    private let hStackLabel: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    let continueButton: OrangeFillButton = {
        $0.setTitle(ButtonTitles.continueButton, for: .normal)
        return $0
    }(OrangeFillButton())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: Colors.orange)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutWhiteView()
        layoutImageView()
        layoutStack()
        layoutContinueButton()
    }
    
    private func layoutWhiteView() {
        addSubview(whiteView)
        
        NSLayoutConstraint.activate([
            whiteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            whiteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            whiteView.heightAnchor.constraint(equalToConstant: 343)
        ])
    }
    
    private func layoutImageView() {
        addSubview(fruitImageView)
        
        NSLayoutConstraint.activate([
            fruitImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 30),
            fruitImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            fruitImageView.bottomAnchor.constraint(equalTo: whiteView.topAnchor, constant: -70),
        ])
    }
    
    private func layoutStack() {
        hStackLabel.addArrangedSubview(titleLabel)
        hStackLabel.addArrangedSubview(descriptionLabel)
        whiteView.addSubview(hStackLabel)
        
        NSLayoutConstraint.activate([
            hStackLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 30),
            hStackLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 25),
            hStackLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -25),
        ])
    }
    
    private func layoutContinueButton() {
        whiteView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            
            continueButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -80),
            continueButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 25),
            continueButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -25),
        ])
    }
}
