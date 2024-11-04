//
//  MenuViewController.swift
//  FruitHub
//
//  Created by Vlad on 1.11.24.
//

import UIKit
import Combine

final class MenuViewController: UIViewController {
    
    private var user: User?
    private var cancellables: Set<AnyCancellable> = []
    
    var viewModel: MenuViewModel?
    private let contentView = MenuView()
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        bindViewModelToView()
        viewModel?.viewDidLoaded()
    }
    
    //MARK: Bind
    private func bindViewModelToView() {
        viewModel?.userPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.user = user
                self?.contentView.setNameLabel(name: user.name)
            })
            .store(in: &cancellables)
        
        viewModel?.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.showAlertError(message: errorMessage)
            })
            .store(in: &cancellables)
    }
    
    //MARK: Targets
    private func addTargets() {
        addTargetForDismissButton()
        addTargetForEditNameButton()
    }
    
    private func addTargetForDismissButton() {
        contentView.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func addTargetForEditNameButton() {
        contentView.editNameButton.addTarget(self, action: #selector(editNameButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Alert
    private func showAlertEditName() {
        let alert = UIAlertController(title: AlertTitle.enterName, message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] textField in
            textField.font = UIFont.systemFont(ofSize: 26, weight: .medium)
            guard let user = self?.user else { return }
            textField.placeholder = "\(user.name)"
        }
        let saveAction = UIAlertAction(title: AlertAction.save, style: .default) { [weak self] action in
            guard let name = alert.textFields?.first?.text else { return }
            self?.viewModel?.updateName(name: name)
        }
        let cancelAction = UIAlertAction(title: AlertAction.cancel, style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: AlertAction.ok, style: .default) { [weak self] _ in
            self?.viewModel?.viewDidLoaded()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}

//MARK: OBJC
extension MenuViewController {
    @objc private func dismissButtonTapped() {
        viewModel?.dismissButtonWasPressed()
    }
    
    @objc private func editNameButtonTapped() {
        showAlertEditName()
    }
}
