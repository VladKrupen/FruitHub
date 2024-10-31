//
//  HomeViewController.swift
//  FruitHub
//
//  Created by Vlad on 23.09.24.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    private var navigationItems: [String] = ["Fruits", "Exotica", "Citrus", "Season", "Favorite"]
    private var selecetedNavigationCell: Int = 0
    
    private var fruitSalads: [FruitSalad] = []
    private var filteredFruitSalads: [FruitSalad] = []
    private var recommendedFruitSalads: [FruitSalad] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        setupAction()
        setupCollectionView()
        bindViewModelToView()
        contentView.showSpiner()
        viewModel?.viewDidLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewModel?.fetchFruitSalads()
    }
    
    //MARK: Bind
    private func bindViewModelToView() {
        viewModel?.fruitSaladPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fruitSalads in
                self?.fruitSalads = fruitSalads
                self?.setRecommendedFruitSalads(fruitSalads: fruitSalads)
                self?.sortFruitSalads()
            })
            .store(in: &cancellables)
        
        viewModel?.userPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] user in
                self?.contentView.configureWelcomeLabel(name: user.name)
            })
            .store(in: &cancellables)
        
        viewModel?.completionPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] results in
                switch results {
                case .success:
                    self?.contentView.hideSpiner()
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            })
            .store(in: &cancellables)
    }
    
    //MARK: Update fruit salads
    private func updateAllFruitSalads(fruitSalad: FruitSalad) {
        guard let index = fruitSalads.firstIndex(where: { $0.id == fruitSalad.id }) else { return }
        fruitSalads[index] = fruitSalad
        sortFruitSalads()
    }
    
    private func updateFilteredFruitSalads(fruitSalad: FruitSalad) {
        guard let index = filteredFruitSalads.firstIndex(where: { $0.id == fruitSalad.id }) else { return }
        filteredFruitSalads[index] = fruitSalad
    }
    
    private func updateRecommendedFruitSalads(fruitSalad: FruitSalad) {
        guard let index = recommendedFruitSalads.firstIndex(where: { $0.id == fruitSalad.id }) else { return }
        recommendedFruitSalads[index] = fruitSalad
    }
    
    //MARK: Sorting
    private func setRecommendedFruitSalads(fruitSalads: [FruitSalad]) {
        recommendedFruitSalads = fruitSalads.filter { $0.isRecommended == true }
        contentView.collectionView.reloadData()
    }
    
    private func sortFruitSalads() {
        switch selecetedNavigationCell {
        case 0:
            filteredFruitSalads = fruitSalads.filter { $0.isFruitSalad == true }
        case 1:
            filteredFruitSalads = fruitSalads.filter { $0.isExoticSalad == true }
        case 2:
            filteredFruitSalads = fruitSalads.filter { $0.isCitrusSalad == true }
        case 3:
            filteredFruitSalads = fruitSalads.filter { $0.isSeasonSalad == true }
        case 4:
            filteredFruitSalads = fruitSalads.filter { $0.isFavorite == true }
        default:
            return
        }
        contentView.collectionView.reloadData()
    }
    
    //MARK: Setup
    private func setupAction() {
        setupGestureForBasketView()
        menuButtonAction()
    }
    
    private func setupGestureForBasketView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(basketViewTapped))
        contentView.basket.addGestureRecognizer(tapGesture)
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
        var recommendedFruitSalad = recommendedFruitSalads[indexPath.item]
        recommendedCell.configureCell(fruitSalad: recommendedFruitSalad)
        recommendedCell.favoriteButtonAction = { [weak self] favorite in
            recommendedFruitSalad.isFavorite = favorite
            self?.updateAllFruitSalads(fruitSalad: recommendedFruitSalad)
            self?.updateFilteredFruitSalads(fruitSalad: recommendedFruitSalad)
            self?.updateRecommendedFruitSalads(fruitSalad: recommendedFruitSalad)
            self?.viewModel?.updateFavoritStateForFruitSalad(fruitSalad: recommendedFruitSalad)
        }
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
        var fruitSalad = filteredFruitSalads[indexPath.item]
        allSaladCell.configureCell(fruitSalad: fruitSalad)
        allSaladCell.favoriteButtonAction = { [weak self] favorite in
            fruitSalad.isFavorite = favorite
            self?.updateAllFruitSalads(fruitSalad: fruitSalad)
            self?.updateFilteredFruitSalads(fruitSalad: fruitSalad)
            self?.updateRecommendedFruitSalads(fruitSalad: fruitSalad)
            self?.viewModel?.updateFavoritStateForFruitSalad(fruitSalad: fruitSalad)
        }
        return allSaladCell
    }
    
    private func didSelectNavigationCell(collectionView: UICollectionView, indexPath: IndexPath) {
        selecetedNavigationCell = indexPath.row
        sortFruitSalads()
        let visibleIndexPaths = collectionView.indexPathsForSelectedItems
        contentView.collectionView.reloadData()
        visibleIndexPaths?.forEach {
            if $0.section == 1 {
                collectionView.scrollToItem(at: $0, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    //MARK: Alert
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.viewModel?.viewDidLoaded()
        }
        alert.addAction(okAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
}

//MARK: OBJC
extension HomeViewController {
    @objc private func basketViewTapped(_ sender: UIButton) {
        AnimationManager.animateClick(view: contentView.basket) { [weak self] in
            self?.viewModel?.goToOrderListModule()
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
            return recommendedFruitSalads.count
        case 1:
            return navigationItems.count
        case 2:
            return filteredFruitSalads.count
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
            viewModel?.goToSaladModule(fruitSalad: recommendedFruitSalads[indexPath.item])
        case 1:
            didSelectNavigationCell(collectionView: collectionView, indexPath: indexPath)
        case 2:
            viewModel?.goToSaladModule(fruitSalad: filteredFruitSalads[indexPath.item])
        default:
            fatalError()
        }
    }
}
