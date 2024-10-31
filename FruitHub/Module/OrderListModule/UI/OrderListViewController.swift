//
//  OrderListViewController.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit
import Combine

final class OrderListViewController: UIViewController {
    
    private var orderList: [FruitSalad] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    var viewModel: OrderListViewModelProtocol?
    private let contentView = OrderListView()
    
    private let backButtonView = BackButtonView()
    
    //MARK: Life cycles
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargetForCheckoutButton()
        setupTableView()
        bindViewModelToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        viewModel?.fetchOrderList()
    }
    
    //MARK: BindViewModelToView
    private func bindViewModelToView() {
        viewModel?.fruitSaladPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fruitSalads in
                self?.orderList = fruitSalads
                self?.contentView.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        viewModel?.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] errorMessage in
                self?.showAlert(message: errorMessage)
            })
            .store(in: &cancellables)
        
        viewModel?.totalAmountPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] totalAmount in
                self?.contentView.configurePriceLabel(total: totalAmount)
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
        navigationItem.title = NavigationItemTitle.orderList
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
    }
    
    private func setupTableView() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
    
    //MARK: Target
    private func addTargetForCheckoutButton() {
        contentView.chekoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    //MARK: Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.viewModel?.backButtonWasPressed()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    //MARK: Remove fruit salad
    private func removeFruitSaladFromBasket(index: Int) {
        viewModel?.removeFruidSaladFromBasket(fruitSalad: orderList[index])
        orderList.remove(at: index)
        viewModel?.updateTotalAmount(orderList: orderList)
    }
}

//MARK: OBJC
extension OrderListViewController {
    @objc private func backButtonViewTapped() {
        viewModel?.backButtonWasPressed()
    }
    
    @objc private func checkoutButtonTapped() {
        AnimationManager.animateClick(view: contentView.chekoutButton) { [weak self] in
            self?.viewModel?.checkoutButtonWasPressed()
        }
    }
}

//MARK: UIGestureRecognizerDelegate
extension OrderListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: UITableViewDataSource
extension OrderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderListCell.self),
                                                       for: indexPath) as? OrderListCell else {
            return UITableViewCell()
        }
        cell.configureCell(fruitSalad: orderList[indexPath.row])
        return cell
    }
}

//MARK: UITableViewDelegate
extension OrderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.cellWasPressed(fruitSalad: orderList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeFruitSaladFromBasket(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
