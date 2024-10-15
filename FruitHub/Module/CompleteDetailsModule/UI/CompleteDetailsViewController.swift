//
//  CompleteDetailsViewController.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit
import Combine

final class CompleteDetailsViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: CompleteDetailsViewModelProtocol?
    private let contentView = CompleteDetailsView()
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModelToView()
    }
    
    //MARK: Bind
    private func bindViewModelToView() {
        viewModel?.deliveryDataErrorMessage
            .sink { [weak self] message in
                self?.showAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    //MARK: Target
    private func addTargets() {
        addTargetForDismissButton()
        addTargetForPayOnDeliveryButton()
        addTargetForPayWithCardButton()
    }
    
    private func addTargetForDismissButton() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func addTargetForPayOnDeliveryButton() {
        contentView.payOnDeliveryButton.addTarget(self, action: #selector(payOnDeliveryButtonTapped), for: .touchUpInside)
    }
    
    private func addTargetForPayWithCardButton() {
        contentView.payWithCardButton.addTarget(self, action: #selector(payWithCardButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}

//MARK: OBJC
extension CompleteDetailsViewController {
    @objc private func dismissButtonTapped() {
        viewModel?.dismissButtonWasPressed()
    }
    
    @objc private func payOnDeliveryButtonTapped() {
        let deliveryData = contentView.getDeliveryData()
        AnimationManager.animateClick(view: contentView.payOnDeliveryButton) { [weak self] in
            self?.contentView.endEditing(true)
            self?.viewModel?.payOnDeliveryButtonWasPressed(deliveryData: deliveryData)
        }
    }
    
    @objc private func payWithCardButtonTapped() {
        let deliveryData = contentView.getDeliveryData()
        AnimationManager.animateClick(view: contentView.payWithCardButton) { [weak self] in
            self?.contentView.endEditing(true)
            self?.viewModel?.payWithCardButtonWasPressed(deliveryData: deliveryData)
        }
    }
}
