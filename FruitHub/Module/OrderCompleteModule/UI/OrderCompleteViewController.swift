//
//  OrderCompleteViewController.swift
//  FruitHub
//
//  Created by Vlad on 14.10.24.
//

import UIKit

final class OrderCompleteViewController: UIViewController {
    
    var viewModel: OrderCompleteViewModelProtocol?
    private let contentView = OrderCompleteView()
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetForGreatButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.startAnimations()
    }
    
    //MARK: Target
    private func addTargetForGreatButton() {
        contentView.greatButton.addTarget(self, action: #selector(greatButtonTapped), for: .touchUpInside)
    }
}

//MARK: OBJC
extension OrderCompleteViewController {
    @objc private func greatButtonTapped() {
        AnimationManager.animateClick(view: contentView.greatButton) { [weak self] in
            self?.viewModel?.greatButtonWasPressed()
        }
    }
}
