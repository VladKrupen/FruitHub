//
//  OrderListCell.swift
//  FruitHub
//
//  Created by Vlad on 11.10.24.
//

import UIKit
import SDWebImage

final class OrderListCell: UITableViewCell {
    
    //MARK: UI
    private let saladImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(hex: Colors.backgroundColorForSaladImageView)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let saladNameLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let numberOfPackagesLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 5
        return $0
    }(UIStackView())
    
    private let priceLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return $0
    }(UILabel())
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configureCell(fruitSalad: FruitSalad) {
        saladImageView.sd_setImage(with: URL(string: fruitSalad.imageUrl),
                                   placeholderImage: UIImage(systemName: SystemImages.placeholderForSaladImage))
        saladNameLabel.text = fruitSalad.nameSalad
        numberOfPackagesLabel.text = "\(fruitSalad.packaging) packs"
        let formattedString = String(format: "%.1f", fruitSalad.price * Float(fruitSalad.packaging))
        priceLabel.text = "$ \(formattedString)"
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutSaladImageView()
        layoutPriceLabel()
        layoutSaladNameLabel()
    }
    
    private func layoutSaladImageView() {
        contentView.addSubview(saladImageView)
        
        NSLayoutConstraint.activate([
            saladImageView.heightAnchor.constraint(equalToConstant: 70),
            saladImageView.widthAnchor.constraint(equalToConstant: 70),
            
            saladImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            contentView.bottomAnchor.constraint(equalTo: saladImageView.bottomAnchor, constant: 15),
            contentView.topAnchor.constraint(equalTo: saladImageView.topAnchor, constant: -40),
        ])
    }
    
    private func layoutPriceLabel() {
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: saladImageView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func layoutSaladNameLabel() {
        vStack.addArrangedSubview(saladNameLabel)
        vStack.addArrangedSubview(numberOfPackagesLabel)
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerYAnchor.constraint(equalTo: saladImageView.centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: saladImageView.trailingAnchor, constant: 10),
            vStack.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10),
        ])
    }
}
