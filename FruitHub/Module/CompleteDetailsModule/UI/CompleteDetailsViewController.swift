//
//  CompleteDetailsViewController.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit

final class CompleteDetailsViewController: UIViewController {
    
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
    }
    
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
}

//MARK: OBJC
extension CompleteDetailsViewController {
    @objc private func dismissButtonTapped() {
        viewModel?.dismissButtonWasPressed()
    }
    
    @objc private func payOnDeliveryButtonTapped() {
        AnimationManager.animateClick(view: contentView.payOnDeliveryButton) { [weak self] in
            self?.viewModel?.payOnDeliveryButtonWasPressed()
        }
    }
    
    @objc private func payWithCardButtonTapped() {
        AnimationManager.animateClick(view: contentView.payWithCardButton) { [weak self] in
            self?.viewModel?.payWithCardButtonWasPressed()
        }
    }
}
