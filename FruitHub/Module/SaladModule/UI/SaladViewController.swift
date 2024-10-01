//
//  SaladViewController.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import UIKit

final class SaladViewController: UIViewController {
    
    var viewModel: SaladViewModelProtocol?
    private let contentView = SaladView()
    
    private let backButtonView = BackButtonView()
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addActionsContentView()
        let salad = FruitSalad(imageUrl: "", nameSalad: "Quinoa fruit salad", price: "10", isFavorite: false)
        contentView.configure(salad: salad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        navigationController?.isNavigationBarHidden = false
        let backButton = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonViewTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func addActionsContentView() {
        addTargetForFavoriteButton()
        addTargetForAddToBasketButton()
        addTapGestureForDecreaseButton()
        addTapGestureForIncreaseButton()
    }
    
    private func addTargetForFavoriteButton() {
        contentView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func addTargetForAddToBasketButton() {
        contentView.addToBasketButton.addTarget(self, action: #selector(addToBasketButtonTapped), for: .touchUpInside)
    }
    
    private func addTapGestureForDecreaseButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(decreaseButtonTapped))
        contentView.decreaseButton.addGestureRecognizer(tapGesture)
    }
    
    private func addTapGestureForIncreaseButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(increaseButtonTapped))
        contentView.increaseButton.addGestureRecognizer(tapGesture)
    }
}

extension SaladViewController {
    @objc private func backButtonViewTapped() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backButtonView.layer.opacity = 0.3
        } completion: { [weak self] bool in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func favoriteButtonTapped() {
        contentView.favoriteButton.isFavorite?.toggle()
    }
    
    @objc private func addToBasketButtonTapped() {
        AnimationManager.animateClick(view: contentView.addToBasketButton) {
            
        }
    }
    
    @objc private func decreaseButtonTapped() {
        AnimationManager.animateClick(view: contentView.decreaseButton) {
            
        }
    }
    
    @objc private func increaseButtonTapped() {
        AnimationManager.animateClick(view: contentView.increaseButton) {
            
        }
    }
}

extension SaladViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
