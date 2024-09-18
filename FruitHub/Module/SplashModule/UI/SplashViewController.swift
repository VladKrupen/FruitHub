//
//  SplashViewController.swift
//  FruitHub
//
//  Created by Vlad on 18.09.24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    var viewModel: SplashViewModelProtocol?
    private let contentView = SplashView()
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateImageView()
    }
    
    private func animateImageView() {
        UIView.animate(withDuration: 2.0) { [weak self] in
            self?.contentView.imageView.layer.opacity = 1
        } completion: { [weak self] _ in
            self?.viewModel?.goToNextScreen()
        }
    }
}
