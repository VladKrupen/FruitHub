//
//  CardDetailsView.swift
//  FruitHub
//
//  Created by Vlad on 13.10.24.
//

import UIKit

final class CardDetailsView: UIView {
    
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
    
    let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        return $0
    }(UIScrollView())
    
    private let cardHoldersNameLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.text = LabelNames.cardHoldersName
        return $0
    }(UILabel())

    private lazy var cardHoldersNameTextField: CustomTextField = {
        $0.placeholder = Placeholders.cardHoldersName
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let cardNumberLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.text = LabelNames.cardNumber
        return $0
    }(UILabel())
    
    private lazy var cardNumberTextField: CustomTextField = {
        $0.placeholder = Placeholders.cardNumber
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let dateLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.text = LabelNames.date
        return $0
    }(UILabel())
    
    private lazy var dateTextField: CustomTextField = {
        $0.widthAnchor.constraint(equalToConstant: 135).isActive = true
        $0.placeholder = Placeholders.date
        $0.textAlignment = .center
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let dateVStack: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private let cvvLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.text = LabelNames.cvv
        return $0
    }(UILabel())
    
    private lazy var cvvTextField: CustomTextField = {
        $0.widthAnchor.constraint(equalToConstant: 135).isActive = true
        $0.placeholder = Placeholders.cvv
        $0.textAlignment = .center
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let cvvVStack: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private let hStack: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        return $0
    }(UIStackView())
    
    private lazy var completeOrderButton: OrangeButton = {
        $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 130).isActive = true
        $0.setTitle(ButtonTitles.payWithCard, for: .normal)
        $0.addTarget(self, action: #selector(completeOrderButtonTapped), for: .touchUpInside)
        return $0
    }(OrangeButton())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElements()
        setupGestureRecognizerForWhiteView()
        scrollingWhenOpeningKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Setup keyboard
    private func scrollingWhenOpeningKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Setup gesture
    private func setupGestureRecognizerForWhiteView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(whiteViewTapped))
        tapGesture.delegate = self
        whiteView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutDismissButton()
        layoutWhiteView()
        layoutScrollView()
        layoutVStack()
        layoutCompleteOrderButton()
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
    
    private func layoutScrollView() {
        whiteView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: whiteView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor),
        ])
    }
    
    private func layoutVStack() {
        vStack.addArrangedSubview(cardHoldersNameLabel)
        vStack.addArrangedSubview(cardHoldersNameTextField)
        vStack.addArrangedSubview(cardNumberLabel)
        vStack.addArrangedSubview(cardNumberTextField)
        
        dateVStack.addArrangedSubview(dateLabel)
        dateVStack.addArrangedSubview(dateTextField)
        
        cvvVStack.addArrangedSubview(cvvLabel)
        cvvVStack.addArrangedSubview(cvvTextField)
        
        hStack.addArrangedSubview(dateVStack)
        hStack.addArrangedSubview(cvvVStack)
        
        vStack.addArrangedSubview(hStack)
        
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            vStack.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutCompleteOrderButton() {
        scrollView.addSubview(completeOrderButton)
        
        NSLayoutConstraint.activate([
            completeOrderButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 30),
            completeOrderButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: completeOrderButton.bottomAnchor, constant: 30),
        ])
    }
}

//MARK: OBJC
extension CardDetailsView {
    @objc private func completeOrderButtonTapped() {
        AnimationManager.animateClick(view: completeOrderButton) {
            
        }
    }
    
    @objc private func whiteViewTapped() {
        endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

//MARK: UITextFieldDelegate
extension CardDetailsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case cardHoldersNameTextField:
            cardNumberTextField.becomeFirstResponder()
        case cardNumberTextField:
            dateTextField.becomeFirstResponder()
        case dateTextField:
            cvvTextField.becomeFirstResponder()
        case cvvTextField:
            endEditing(true)
        default:
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldRect = textField.convert(textField.bounds, to: scrollView)
        let offsetY = textFieldRect.maxY - scrollView.bounds.height + scrollView.contentInset.bottom + 100
        if offsetY > 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }
}

//MARK: UIGestureRecognizerDelegate
extension CardDetailsView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}