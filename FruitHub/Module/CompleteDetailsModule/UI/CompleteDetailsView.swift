//
//  CompleteDetailsView.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit

final class CompleteDetailsView: UIView {
    
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
    
    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 20
        return $0
    }(UIScrollView())
    
    private let deliveryAddressLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.text = LabelNames.deliveryAddress
        return $0
    }(UILabel())
    
    private lazy var deliveryAddressTextField: CustomTextField = {
        $0.placeholder = Placeholders.deliveryAddress
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let numberPhoneLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.text = LabelNames.numberPhone
        return $0
    }(UILabel())
    
    private lazy var numberPhoneTextField: CustomTextField = {
        $0.placeholder = Placeholders.numberPhone
        $0.delegate = self
        return $0
    }(CustomTextField())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    let payOnDeliveryButton: OrangeButton = {
        $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 130).isActive = true
        $0.setTitle(ButtonTitles.payOnDelivery, for: .normal)
        return $0
    }(OrangeButton())
    
    let payWithCardButton: OrangeButton = {
        $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 130).isActive = true
        $0.setTitle(ButtonTitles.payWithCard, for: .normal)
        return $0
    }(OrangeButton())
    
    private let hStackButton: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .equalSpacing
        $0.axis = .horizontal
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
    
    private func scrollingWhenOpeningKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
        layoutHStackButton()
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
        vStack.addArrangedSubview(deliveryAddressLabel)
        vStack.addArrangedSubview(deliveryAddressTextField)
        vStack.addArrangedSubview(numberPhoneLabel)
        vStack.addArrangedSubview(numberPhoneTextField)
        
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            vStack.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutHStackButton() {
        hStackButton.addArrangedSubview(payOnDeliveryButton)
        hStackButton.addArrangedSubview(payWithCardButton)
        scrollView.addSubview(hStackButton)
        
        NSLayoutConstraint.activate([
            hStackButton.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 30),
            hStackButton.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 20),
            hStackButton.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: hStackButton.bottomAnchor, constant: 30)
        ])
    }
}

extension CompleteDetailsView {
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
extension CompleteDetailsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case deliveryAddressTextField:
            numberPhoneTextField.becomeFirstResponder()
        case numberPhoneTextField:
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

extension CompleteDetailsView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
