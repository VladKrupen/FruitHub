//
//  OrderListView.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit

final class OrderListView: UIView {
    
    //MARK: UI
    private let whiteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    private let vStack: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private let totalLabel: UILabel = {
        $0.text = LabelNames.total
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private let priceLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 24)
        return $0
    }(UILabel())
    
    let chekoutButton: OrangeFillButton = {
        $0.setTitle(ButtonTitles.checkout, for: .normal)
        return $0
    }(OrangeFillButton())
    
    private let hStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 30
        return $0
    }(UIStackView())

    let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(OrderListCell.self, forCellReuseIdentifier: String(describing: OrderListCell.self))
        $0.bounces = false
        return $0
    }(UITableView())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: Colors.orange)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configurePriceLabel(total: Float) {
        let formattedString = String(format: "%.1f", total)
        priceLabel.text = "$ \(formattedString)"
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutWhiteView()
        layoutHStack()
        layoutTableView()
    }
    
    private func layoutWhiteView() {
        addSubview(whiteView)
        
        NSLayoutConstraint.activate([
            whiteView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            whiteView.bottomAnchor.constraint(equalTo: bottomAnchor),
            whiteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func layoutHStack() {
        vStack.addArrangedSubview(totalLabel)
        vStack.addArrangedSubview(priceLabel)

        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(chekoutButton)
        
        whiteView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            chekoutButton.heightAnchor.constraint(equalToConstant: 56),
            hStack.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -50),
            hStack.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutTableView() {
        whiteView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: whiteView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: hStack.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor),
        ])
    }
}
