//
//  HomeViewController.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var navigationItems: [String] = ["Hottest", "Popular", "New combo", "Top"]
    private var selecetedNavigationCell: Int = 0
    
    //MARK: Dependency
    var viewModel: HomeViewModelProtocol?
    private let contentView = HomeView()
    
    //MARK: Life cycle
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupAction()
        setupCollectionView()
    }
    
    //MARK: Setup
    private func setupAction() {
        setupGestureForBasketView()
        menuButtonAction()
    }
    
    private func setupGestureForBasketView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(basketViewTapped))
        contentView.basketView.addGestureRecognizer(tapGesture)
    }
    
    private func menuButtonAction() {
        contentView.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    //MARK: CollectionView
    private func setupCollectionView() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    //MARK: Cell
    private func getRecommendedCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let recommendedCell = collectionView.dequeueReusableCell(withReuseIdentifier: SaladCellIdentifier.recommendedSalad, for: indexPath) as? SaladCell else {
            return UICollectionViewCell(frame: .zero)
        }
        let recommended = FruitSalad(imageUrl: "https://w7.pngwing.com/pngs/259/411/png-transparent-computer-icons-text-information-link-blue-angle-text.png", nameSalad: "Honey lime combo", price: "5", isFavorite: false)
        recommendedCell.configureCell(recommended: recommended)
        return recommendedCell
    }
    
    private func getNavigationCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let navigationCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NavigationCell.self), for: indexPath) as? NavigationCell else {
            return UICollectionViewCell(frame: .zero)
        }
        navigationCell.configureCell(title: navigationItems[indexPath.row])
        if indexPath.row == selecetedNavigationCell {
            navigationCell.selectCell()
        } else {
            navigationCell.deselectCell()
        }
        return navigationCell
    }
    
    private func getAllSaladCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let allSaladCell = collectionView.dequeueReusableCell(withReuseIdentifier: SaladCellIdentifier.allSalad, for: indexPath) as? SaladCell else {
            return UICollectionViewCell(frame: .zero)
        }
        let recommended = FruitSalad(imageUrl: "https://w7.pngwing.com/pngs/259/411/png-transparent-computer-icons-text-information-link-blue-angle-text.png", nameSalad: "Honey lime combo", price: "5", isFavorite: false)
        allSaladCell.configureCell(recommended: recommended)
        return allSaladCell
    }
    
    private func didSelectNavigationCell(collectionView: UICollectionView, indexPath: IndexPath) {
        selecetedNavigationCell = indexPath.row
        let visibleIndexPaths = collectionView.indexPathsForSelectedItems
        collectionView.reloadSections(IndexSet(integer: 1))
        visibleIndexPaths?.forEach {
            if $0.section == 1 {
                collectionView.scrollToItem(at: $0, at: .centeredHorizontally, animated: false)
            }
        }
    }
}

//MARK: OBJC
extension HomeViewController {
    @objc private func basketViewTapped(_ sender: UIButton) {
        AnimationManager.animateClick(view: contentView.basketView) {
          
        }
    }
    
    @objc private func menuButtonTapped() {
        AnimationManager.animateClick(view: contentView.menuButton) {
            
        }
    }
}

//MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return navigationItems.count
        case 2:
            return 3
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            getRecommendedCell(collectionView: collectionView, indexPath: indexPath)
        case 1:
            getNavigationCell(collectionView: collectionView, indexPath: indexPath)
        case 2:
            getAllSaladCell(collectionView: collectionView, indexPath: indexPath)
        default:
            fatalError()
        }
    }
}

//MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(indexPath)
        case 1:
            didSelectNavigationCell(collectionView: collectionView, indexPath: indexPath)
        case 2:
            print(indexPath)
        default:
            fatalError()
        }
    }
}
