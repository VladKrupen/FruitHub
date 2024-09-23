//
//  EnterNameView.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class EnterNameView: UIView {
    
    var startOrderingButtonAction: ((String) -> Void)?
    private var originalOriginY: CGFloat = .zero
    private var keyboardIsVisible: Bool = false
    
    //MARK: UI
    private let whiteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: Colors.white)
        return $0
    }(UIView())
    
    private let fruitImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: ImageAssets.enternameFruit)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.userFirstNameInquiry
        $0.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return $0
    }(UILabel())
    
    private lazy var nameField: CustomTextField = {
        $0.placeholder = Placeholders.nameField
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let hStackLabel: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private lazy var startOrderingButton: OrangeButton = {
        $0.setTitle(ButtonTitles.startOrdering, for: .normal)
        $0.addTarget(self, action: #selector(startOrderingButtonTapped), for: .touchUpInside)
        return $0
    }(OrangeButton())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: Colors.orange)
        layoutElements()
        scrollingWhenOpeningKeyboard()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Setup
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func scrollingWhenOpeningKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutWhiteView()
        layoutImageView()
        layoutStack()
        layoutStartOrderingButton()
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
        hStackLabel.addArrangedSubview(nameField)
        
        whiteView.addSubview(hStackLabel)
        
        NSLayoutConstraint.activate([
            hStackLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 30),
            hStackLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 25),
            hStackLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -25),
        ])
    }
    
    private func layoutStartOrderingButton() {
        whiteView.addSubview(startOrderingButton)
        
        NSLayoutConstraint.activate([
            startOrderingButton.heightAnchor.constraint(equalToConstant: 56),
            
            startOrderingButton.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -80),
            startOrderingButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 25),
            startOrderingButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -25),
        ])
    }
}

//MARK: OBJC
extension EnterNameView {
    @objc private func startOrderingButtonTapped() {
        AnimationManager.animateClick(view: startOrderingButton) { [weak self] in
            guard let name = self?.nameField.text else { return }
            self?.startOrderingButtonAction?(name)
            self?.endEditing(true)
        }
    }
    
    @objc private func viewTapped() {
        endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsVisible {
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let keyboardHeight = keyboardFrame.height
                originalOriginY = self.frame.origin.y
                self.frame.origin.y -= keyboardHeight - 50
                keyboardIsVisible = true
                setNeedsLayout()
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.frame.origin.y = originalOriginY
        keyboardIsVisible = false
        setNeedsLayout()
    }
}

//MARK: UITextFieldDelegate
extension EnterNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
    }
}
