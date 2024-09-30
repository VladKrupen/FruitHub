//
//  NavigationCell.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import UIKit

final class NavigationCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let separator: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        $0.backgroundColor = UIColor(hex: Colors.orange)
        return $0
    }(UIView())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
    
    func selectCell() {
        UIView.transition(with: self, duration: 0.3, options: .allowAnimatedContent, animations: { [weak self] in
            self?.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .light)
            self?.separator.isHidden = false
        })
    }
    
    func deselectCell() {
        UIView.transition(with: self, duration: 0.3, options: .allowAnimatedContent, animations: { [weak self] in
            self?.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            self?.separator.isHidden = true
        })
    }
    
    private func layoutElements() {
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(separator)
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: vStack.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
            
            separator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
}
