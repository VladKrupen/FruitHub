//
//  CardDetailsViewController.swift
//  FruitHub
//
//  Created by Vlad on 13.10.24.
//

import UIKit
import Combine

final class CardDetailsViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: CardDetailsViewModelProtocol?
    private let contentView = CardDetailsView()
    
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
        viewModel?.cardDataErrorMessage
            .sink { [weak self] message in
                self?.showAlert(message: message)
            }
            .store(in: &cancellables)
    }
    
    //MARK: Targets
    private func addTargets() {
        addTargetForDismissButton()
        addTargetForCompleteOrderButton()
    }
    
    private func addTargetForDismissButton() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func addTargetForCompleteOrderButton() {
        contentView.completeOrderButton.addTarget(self, action: #selector(completeOrderButtonTapped), for: .touchUpInside)
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
extension CardDetailsViewController {
    @objc private func dismissButtonTapped() {
        viewModel?.dismissButtonWasPressed()
    }
    
    @objc private func completeOrderButtonTapped() {
        let cardData = contentView.getCardData()
        AnimationManager.animateClick(view: contentView.completeOrderButton) { [weak self] in
            self?.contentView.endEditing(true)
            self?.viewModel?.completeOrderButtonWasPressed(cardData: cardData)
        }
    }
}
