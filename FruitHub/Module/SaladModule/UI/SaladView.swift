//
//  SaladView.swift
//  FruitHub
//
//  Created by Vlad on 30.09.24.
//

import UIKit
import SDWebImage

final class SaladView: UIView {
    
    private var price: Float?
    
    //MARK: UI
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.tintColor = .white
        $0.layer.cornerRadius = 20
        return $0
    }(UIImageView())
    
    private let whiteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        return $0
    }(UIView())
    
    let favoriteButton: FavoriteButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isFavorite = false
        return $0
    }(FavoriteButton())
    
    let orangeFillButton: OrangeFillButton = {
        return $0
    }(OrangeFillButton())
    
    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 25
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    private let nameSaladLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return $0
    }(UILabel())
    
    let decreaseButton: CounterChange = {
        $0.setImage(string: SystemImages.minus)
        $0.isActive = false
        return $0
    }(CounterChange())
    
    let increaseButton: CounterChange = {
        $0.setImage(string: SystemImages.plus)
        $0.isActive = true
        return $0
    }(CounterChange())
    
    private let counterLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let counterHStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 20
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    private let priceLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let firstSeparator: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        $0.backgroundColor = .systemGray5
        return $0
    }(UILabel())
    
    private let packContainsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.text = LabelNames.onePackContains
        return $0
    }(UILabel())
    
    private let orangeSeparator: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
        $0.backgroundColor = UIColor(hex: Colors.orange)
        return $0
    }(UIView())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.contentMode = .center
        $0.spacing = 5
        return $0
    }(UIStackView())
    
    private let compositionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
        return $0
    }(UILabel())
    
    private let secondSeparator: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        $0.backgroundColor = .systemGray5
        return $0
    }(UILabel())
    
    private let noteLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return $0
    }(UILabel())
    
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
    func configureView(salad: FruitSalad) {
        imageView.sd_setImage(with: URL(string: salad.imageUrl),
                              placeholderImage: UIImage(systemName: SystemImages.placeholderForSaladImage))
        nameSaladLabel.text = salad.nameSalad
        price = salad.price
        priceLabel.text = "$ \(salad.price)"
        compositionLabel.text = salad.compound
        noteLabel.text = salad.description
        favoriteButton.isFavorite = salad.isFavorite
    }
    
    func updateCounterAndPriceLables(counter: Int) {
        counterLabel.text = "\(counter)"
        guard let price = price else { return }
        let formattedString = String(format: "%.1f", Float(counter) * price)
        priceLabel.text = "$ \(formattedString)"
    }
    
    //MARK: Lauout
    private func layoutElements() {
        layoutImageView()
        layoutWhiteView()
        layoutFavoriteButton()
        layoutAddToBasketButton()
        layoutScrollView()
        layoutNameSaladLabel()
        layoutCounterHStack()
        layoutPriceLabel()
        layoutFirstSeparator()
        layoutVStack()
        layoutCompositionLabel()
        layoutSecondSeparator()
        layoutNoteLabel()
    }

    private func layoutImageView() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func layoutWhiteView() {
        addSubview(whiteView)
        
        NSLayoutConstraint.activate([
            whiteView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            whiteView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whiteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            whiteView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 50)
        ])
    }
    
    private func layoutFavoriteButton() {
        whiteView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            
            favoriteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutAddToBasketButton() {
        whiteView.addSubview(orangeFillButton)
        
        NSLayoutConstraint.activate([
            orangeFillButton.heightAnchor.constraint(equalToConstant: 56),
            
            orangeFillButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            orangeFillButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            orangeFillButton.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: 70),
            favoriteButton.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor)
        ])
    }
    
    private func layoutScrollView() {
        whiteView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: whiteView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: orangeFillButton.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor),
        ])
    }
    
    private func layoutNameSaladLabel() {
        scrollView.addSubview(nameSaladLabel)
        
        NSLayoutConstraint.activate([
            nameSaladLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
            nameSaladLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameSaladLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutCounterHStack() {
        counterHStack.addArrangedSubview(decreaseButton)
        counterHStack.addArrangedSubview(counterLabel)
        counterHStack.addArrangedSubview(increaseButton)
        
        scrollView.addSubview(counterHStack)
        
        NSLayoutConstraint.activate([
            counterLabel.widthAnchor.constraint(equalToConstant: 30),
            
            counterHStack.topAnchor.constraint(equalTo: nameSaladLabel.bottomAnchor, constant: 30),
            counterHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutPriceLabel() {
        scrollView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: counterHStack.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutFirstSeparator() {
        scrollView.addSubview(firstSeparator)
        
        NSLayoutConstraint.activate([
            firstSeparator.topAnchor.constraint(equalTo: counterHStack.bottomAnchor, constant: 35),
            firstSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func layoutVStack() {
        vStack.addArrangedSubview(packContainsLabel)
        vStack.addArrangedSubview(orangeSeparator)
        
        scrollView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: firstSeparator.bottomAnchor, constant: 35),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutCompositionLabel() {
        scrollView.addSubview(compositionLabel)
        
        NSLayoutConstraint.activate([
            compositionLabel.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20),
            compositionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            compositionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutSecondSeparator() {
        scrollView.addSubview(secondSeparator)
        
        NSLayoutConstraint.activate([
            secondSeparator.topAnchor.constraint(equalTo: compositionLabel.bottomAnchor, constant: 20),
            secondSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func layoutNoteLabel() {
        scrollView.addSubview(noteLabel)
        
        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: secondSeparator.bottomAnchor, constant: 20),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            scrollView.bottomAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 20)
        ])
    }
}
