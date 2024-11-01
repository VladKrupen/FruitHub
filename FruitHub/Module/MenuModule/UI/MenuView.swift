//
//  MenuView.swift
//  FruitHub
//
//  Created by Vlad on 1.11.24.
//

import UIKit

final class MenuView: UIView {
    
    //MARK: UI
    let dismissButton: XmarkButton = {
        return $0
    }(XmarkButton())
    
    private let whiteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        return $0
    }(UIView())
    
    let editNameButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: SystemImages.pencil), for: .normal)
        $0.tintColor = UIColor(hex: Colors.orange)
        return $0
    }(UIButton(type: .system))
    
    private let nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func setNameLabel(name: String) {
        nameLabel.text = "Name: \(name)"
        guard let text = nameLabel.text else { return }
        setAttributedTextForNameLabel(text: text)
    }
    
    //MARK: AttributedText
    private func setAttributedTextForNameLabel(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .light)],
                                       range: NSRange(location: 0, length: 5))
        nameLabel.attributedText = attributedString
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutDismissButton()
        layoutWhiteView()
        layoutEditNameButton()
        layoutNameLabel()
    }
    
    private func layoutDismissButton() {
        addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissButton.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    private func layoutWhiteView() {
        addSubview(whiteView)
        
        NSLayoutConstraint.activate([
            whiteView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 10),
            whiteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            whiteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func layoutEditNameButton() {
        whiteView.addSubview(editNameButton)
        
        NSLayoutConstraint.activate([
            editNameButton.widthAnchor.constraint(equalToConstant: 22),
            editNameButton.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 40),
            editNameButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -20)
        ])
    }
    
    private func layoutNameLabel() {
        whiteView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: editNameButton.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: editNameButton.leadingAnchor, constant: -10),
        ])
    }
}
