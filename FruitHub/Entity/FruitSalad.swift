//
//  RecommendedCombo.swift
//  FruitHub
//
//  Created by Vlad on 25.09.24.
//

import Foundation

struct FruitSalad: Codable {
    let id: String
    let imageUrl: String
    let nameSalad: String
    let price: Float
    var isFavorite: Bool
    let compound: String
    let description: String
    let isRecommended: Bool
    let isFruitSalad: Bool
    let isExoticSalad: Bool
    let isCitrusSalad: Bool
    let isSeasonSalad: Bool
    var isBasket: Bool
    var packaging: Int
}

struct FruitSaladHashable: Hashable {
    let id: String
    let imageUrl: String
    let nameSalad: String
    let price: Float
    let compound: String
    let description: String
    let isRecommended: Bool
    let isFruitSalad: Bool
    let isExoticSalad: Bool
    let isCitrusSalad: Bool
    let isSeasonSalad: Bool
}
