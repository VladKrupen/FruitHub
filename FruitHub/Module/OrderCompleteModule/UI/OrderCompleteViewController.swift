//
//  OrderCompleteViewController.swift
//  FruitHub
//
//  Created by Vlad on 14.10.24.
//

import UIKit
import Combine

final class OrderCompleteViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        bindViewModelToView()
        viewModel?.viewDidLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.startAnimations()
    }
    
    //MARK: BindViewModelToView
    private func bindViewModelToView() {
        viewModel?.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            })
            .store(in: &cancellables)
    }
    
    //MARK: Target
    private func addTargetForGreatButton() {
        contentView.greatButton.addTarget(self, action: #selector(greatButtonTapped), for: .touchUpInside)
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
extension OrderCompleteViewController {
    @objc private func greatButtonTapped() {
        AnimationManager.animateClick(view: contentView.greatButton) { [weak self] in
            self?.viewModel?.greatButtonWasPressed()
        }
    }
}
