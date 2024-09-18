//
//  WelcomeViewController.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    var viewModel: ScreenTransition?
    private var contentView = WelcomeView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargetForContinueButton()
    }
    
    private func setTargetForContinueButton() {
        contentView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
}

extension WelcomeViewController {
    @objc private func continueButtonTapped() {
        viewModel?.goToNextScreen()
    }
}
