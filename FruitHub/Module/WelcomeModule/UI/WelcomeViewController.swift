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
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargetForContinueButton()
    }
    
    //MARK: Setup
    private func setTargetForContinueButton() {
        contentView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
}

//MARK: OBJC
extension WelcomeViewController {
    @objc private func continueButtonTapped() {
        AnimationManager.animateClick(view: contentView.continueButton) { [weak self] in
            self?.viewModel?.goToNextScreen()
        }
    }
}
