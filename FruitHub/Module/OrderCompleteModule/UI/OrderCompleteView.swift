//
//  OrderCompleteView.swift
//  FruitHub
//
//  Created by Vlad on 14.10.24.
//

import UIKit

final class OrderCompleteView: UIView {
    
    //MARK: UI
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = UIImage(named: ImageAssets.complete)
        $0.alpha = 0
        return $0
    }(UIImageView())
    
    private let congratulationLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.congratulation
        $0.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        $0.alpha = 0
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.descriptionForOrderCompleteView
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.alpha = 0
        return $0
    }(UILabel())
    
    let greatButton: OrangeFillButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(ButtonTitles.great, for: .normal)
        $0.alpha = 0
        return $0
    }(OrangeFillButton())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimations() {
        UIView.animate(withDuration: 1) { [weak self] in
            self?.imageView.alpha = 1
            self?.congratulationLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1) { [weak self] in
                self?.descriptionLabel.alpha = 1
                self?.greatButton.alpha = 1
            }
        }
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutImageView()
        layoutCongratulationsLabel()
        layoutDescriptionLabel()
        layoutGreatButton()
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 165),
            imageView.widthAnchor.constraint(equalToConstant: 165),
            
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func layoutCongratulationsLabel() {
        addSubview(congratulationLabel)
        
        NSLayoutConstraint.activate([
            congratulationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            congratulationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40)
        ])
    }
    
    private func layoutDescriptionLabel() {
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: congratulationLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
        ])
    }
    
    private func layoutGreatButton() {
        addSubview(greatButton)
        
        NSLayoutConstraint.activate([
            greatButton.heightAnchor.constraint(equalToConstant: 56),
            greatButton.widthAnchor.constraint(equalToConstant: 135),
            
            greatButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            greatButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
