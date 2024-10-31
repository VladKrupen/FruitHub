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
        viewModel?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    //MARK: Bind
    private func bindViewModelToView() {
        viewModel?.counterPublisher
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
        
        viewModel?.fruitSaladPublisher
            .sink(receiveValue: { [weak self] fruiSalad in
                self?.contentView.configureView(salad: fruiSalad)
            })
            .store(in: &cancellables)
        
        viewModel?.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            })
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
    
    //MARK: Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.viewModel?.handleCompletion()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}

//MARK: OBJC
extension SaladViewController {
    @objc private func backButtonViewTapped() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.backButtonView.layer.opacity = 0.3
        } completion: { [weak self] bool in
            self?.viewModel?.handleCompletion()
        }
    }
    
    @objc private func favoriteButtonTapped() {
        contentView.favoriteButton.isFavorite?.toggle()
        guard let favorite = contentView.favoriteButton.isFavorite else { return }
        viewModel?.favoriteButtonWasPressed(favorite: favorite)
    }
    
    @objc private func addToBasketButtonTapped() {
        AnimationManager.animateClick(view: contentView.addToBasketButton) { [weak self] in
            guard let favorite = self?.contentView.favoriteButton.isFavorite else { return }
            self?.viewModel?.addToBasketButtonWasPressed(favorite: favorite)
        }
    }
    
    @objc private func decreaseButtonTapped() {
        AnimationManager.animateClick(view: contentView.decreaseButton) { [weak self] in
            self?.viewModel?.decreaseButtonWasPressed()
        }
    }
    
    @objc private func increaseButtonTapped() {
        AnimationManager.animateClick(view: contentView.increaseButton) { [weak self] in
            self?.viewModel?.increaseButtonWasPressed()
        }
    }
}

//MARK: UIGestureRecognizerDelegate
extension SaladViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
