//
//  EnterNameViewController.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit
import Combine

final class EnterNameViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: EnterNameViewModelProtocol?
    private let contentView = EnterNameView()
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startOrderingButtonTapped()
        bindViewModelToView()
    }
    
    //MARK: Bind
    private func bindViewModelToView() {
        viewModel?.nameEmptyErrorMessage
            .sink { [weak self] message in
                self?.showAlertEmptyField(message: message)
            }
            .store(in: &cancellables)
    }
    
    //MARK: Setup
    private func startOrderingButtonTapped() {
        contentView.startOrderingButtonAction = { [weak self] name in
            self?.viewModel?.checkIfNameIsEmpty(name: name)
        }
    }
    
    //MARK: Alert
    private func showAlertEmptyField(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
