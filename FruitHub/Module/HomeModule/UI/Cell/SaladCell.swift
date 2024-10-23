//
//  SaladCell.swift
//  FruitHub
//
//  Created by Vlad on 24.09.24.
//

import UIKit
import SDWebImage

final class SaladCell: UICollectionViewCell {
    
    //MARK: UI
    private let customView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        return $0
    }(UIView())
    
    private let saladImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.tintColor = UIColor(hex: Colors.orange)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        return $0
    }(UIImageView())
    
    private let saladNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private lazy var plusButton: PlusButton = {
        $0.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return $0
    }(PlusButton(type: .system))
    
    private let priceLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.textColor = UIColor(hex: Colors.orange)
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private lazy var favoriteButton: FavoriteButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return $0
    }(FavoriteButton(type: .system))
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configureCell(fruitSalad: FruitSalad) {
        saladImageView.sd_setImage(with: URL(string: fruitSalad.imageUrl), placeholderImage: UIImage(systemName: SystemImages.placeholderForSaladImage))
        priceLabel.text = "$ \(fruitSalad.price)"
        saladNameLabel.text = fruitSalad.nameSalad
        favoriteButton.isFavorite = fruitSalad.isFavorite
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutCustomView()
        layoutSaladImageView()
        layoutSaladNameLabel()
        layoutPlusButton()
        layoutPriceLabel()
        layoutFavoriteButton()
    }
    
    private func layoutCustomView() {
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func layoutSaladImageView() {
        customView.addSubview(saladImageView)
        
        NSLayoutConstraint.activate([
            saladImageView.widthAnchor.constraint(equalToConstant: 80),
            saladImageView.heightAnchor.constraint(equalToConstant: 80),
            
            saladImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20),
            saladImageView.centerXAnchor.constraint(equalTo: customView.centerXAnchor)
        ])
    }
    
    private func layoutSaladNameLabel() {
        customView.addSubview(saladNameLabel)
        
        NSLayoutConstraint.activate([
            saladNameLabel.topAnchor.constraint(equalTo: saladImageView.bottomAnchor, constant: 10),
            saladNameLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10),
            saladNameLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10),
        ])
    }
    
    private func layoutPlusButton() {
        customView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: saladNameLabel.bottomAnchor, constant: 10),
            plusButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -15),
            
            customView.bottomAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: customView.bottomAnchor)
        ])
    }
    
    private func layoutPriceLabel() {
        customView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -10),
        ])
    }
    
    private func layoutFavoriteButton() {
        customView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            favoriteButton.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10),
        ])
    }
}

//MARK: OBJC
extension SaladCell {
    @objc private func plusButtonTapped() {
        
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButton.isFavorite?.toggle()
    }
}
