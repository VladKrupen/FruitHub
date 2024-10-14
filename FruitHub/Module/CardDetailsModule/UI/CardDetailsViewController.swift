//
//  CardDetailsViewController.swift
//  FruitHub
//
//  Created by Vlad on 13.10.24.
//

import UIKit

final class CardDetailsViewController: UIViewController {
    
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
    }
    
    //MARK: Targets
    private func addTargets() {
        addTargetForDismissButton()
    }
    
    private func addTargetForDismissButton() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func completeOrderButtonTapped() {
        contentView.completeOrderButtonAction = { [weak self] in
            self?.viewModel?.completeOrderButtonWasPressed()
        }
    }
}

//MARK: OBJC
extension CardDetailsViewController {
    @objc private func dismissButtonTapped() {
        viewModel?.dismissButtonWasPressed()
    }
}
