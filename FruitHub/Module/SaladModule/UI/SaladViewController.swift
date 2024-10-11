//
//  SaladViewController.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import UIKit
import Combine

final class SaladViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
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
        bindViewModelToView()
        let salad = FruitSalad(imageUrl: "", nameSalad: "Quinoa fruit salad", price: 10, isFavorite: false)
        contentView.configureView(salad: salad)
        viewModel?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    //MARK: Bind
    private func bindViewModelToView() {
        viewModel?.counter
            .sink { [weak self] value in
                switch value {
                case _ where value == 10:
                    self?.contentView.increaseButton.isActive = false
                case _ where value > 1:
                    self?.contentView.decreaseButton.isActive = true
                    self?.contentView.increaseButton.isActive = true
                default:
                    self?.contentView.decreaseButton.isActive = false
                }
                self?.contentView.updateCounterAndPriceLables(counter: value)
            }
            .store(in: &cancellables)
    }
    
    //MARK: Setup
    private func setupNavigationController() {
        navigationController?.isNavigationBarHidden = false
        let backButton = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonViewTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    //MARK: Actions
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

//MARK: OBJC
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
        AnimationManager.animateClick(view: contentView.decreaseButton) { [weak self] in
            self?.viewModel?.decreaseButtonPressed()
        }
    }
    
    @objc private func increaseButtonTapped() {
        AnimationManager.animateClick(view: contentView.increaseButton) { [weak self] in
            self?.viewModel?.increaseButtonPressed()
        }
    }
}

//MARK: UIGestureRecognizerDelegate
extension SaladViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
