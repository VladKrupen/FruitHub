//
//  EnterNameViewController.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class EnterNameViewController: UIViewController {
    
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
    }
    
    //MARK: Setup
    private func startOrderingButtonTapped() {
        contentView.startOrderingButtonAction = { [weak self] name in
            guard !name.isEmpty else {
                self?.showAlertEmptyField()
                return
            }
            self?.viewModel?.goToNextScreen()
        }
    }
    
    //MARK: Alert
    private func showAlertEmptyField() {
        let alert = UIAlertController(title: nil, message: "Please enter your name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}
