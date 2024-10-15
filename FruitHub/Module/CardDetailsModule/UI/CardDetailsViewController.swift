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
        completeOrderButtonTapped()
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
    }
    
    private func addTargetForDismissButton() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func completeOrderButtonTapped() {
        contentView.completeOrderButtonAction = { [weak self] cardData in
            self?.viewModel?.completeOrderButtonWasPressed(cardData: cardData)
            print(cardData)
        }
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
}
