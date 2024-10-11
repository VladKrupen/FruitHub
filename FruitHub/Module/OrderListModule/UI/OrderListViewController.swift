//
//  OrderListViewController.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit

final class OrderListViewController: UIViewController {
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
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
}

//MARK: OBJC
extension OrderListViewController {
    @objc private func backButtonViewTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func checkoutButtonTapped() {
        AnimationManager.animateClick(view: contentView.chekoutButton) {
            
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderListCell.self),
                                                       for: indexPath) as? OrderListCell else {
            return UITableViewCell()
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension OrderListViewController: UITableViewDelegate {
    
}
