//
//  HomeView.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class HomeView: UIView {
    
    //MARK: UI
    let basketView: BasketView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        return $0
    }(BasketView())
    
    let menuButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: SystemImages.menuButton), for: .normal)
        $0.tintColor = .black
        return $0
    }(UIButton())
    
    private let welcomeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20)
        return $0
    }(UILabel())
    
    private let recomendedComboLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = LabelNames.recommendedCombo
        $0.font = UIFont.systemFont(ofSize: 24)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    lazy var collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(hex: Colors.white)
        $0.alwaysBounceVertical = false
        $0.register(SaladCell.self, forCellWithReuseIdentifier: SaladCellIdentifier.recommendedSalad)
        $0.register(NavigationCell.self, forCellWithReuseIdentifier: String(describing: NavigationCell.self))
        $0.register(SaladCell.self, forCellWithReuseIdentifier: SaladCellIdentifier.allSalad)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: getCompositionLayout()))
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: Colors.white)
        layoutElements()
        configureWelcomeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configureWelcomeLabel() {
        welcomeLabel.text = "Hello Alex, What fruit salad combo do you want today?"
    }
    
    private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.425), heightDimension: .estimated(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let recommendedHorizontalSection = NSCollectionLayoutSection(group: group)
                recommendedHorizontalSection.interGroupSpacing = 20
                recommendedHorizontalSection.orthogonalScrollingBehavior = .groupPaging
                recommendedHorizontalSection.contentInsets = .init(top: 10, leading: 20, bottom: 0, trailing: 20)
                return recommendedHorizontalSection
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .estimated(30))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let navigationHorizontalSection = NSCollectionLayoutSection(group: group)
                navigationHorizontalSection.interGroupSpacing = 20
                navigationHorizontalSection.orthogonalScrollingBehavior = .groupPaging
                navigationHorizontalSection.contentInsets = .init(top: 50, leading: 20, bottom: 0, trailing: 20)
                return navigationHorizontalSection
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.39), heightDimension: .estimated(1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let recommendedHorizontalSection = NSCollectionLayoutSection(group: group)
                recommendedHorizontalSection.interGroupSpacing = 20
                recommendedHorizontalSection.orthogonalScrollingBehavior = .groupPaging
                recommendedHorizontalSection.contentInsets = .init(top: 30, leading: 20, bottom: 30, trailing: 20)
                return recommendedHorizontalSection
            default:
                fatalError()
            }
        }
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutBasketButton()
        layoutMenuButton()
        layoutWelcomeLabel()
        layooutRecommendedComboLabel()
        layoutCollectionView()
    }
    
    private func layoutBasketButton() {
        addSubview(basketView)
        
        NSLayoutConstraint.activate([
            basketView.widthAnchor.constraint(equalToConstant: 45),
            basketView.heightAnchor.constraint(equalToConstant: 38),
            
            basketView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            basketView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutMenuButton() {
        addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 45),
            menuButton.heightAnchor.constraint(equalToConstant: 38),
            
            menuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            menuButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutWelcomeLabel() {
        addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 30),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func layooutRecommendedComboLabel() {
        addSubview(recomendedComboLabel)
        
        NSLayoutConstraint.activate([
            recomendedComboLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            recomendedComboLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recomendedComboLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: recomendedComboLabel.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
