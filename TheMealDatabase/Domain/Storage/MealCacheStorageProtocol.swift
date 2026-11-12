//
//  MealCacheStorageProtocol.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import Foundation

protocol MealCacheStorageProtocol {
    func searchFromCache(query: String) async -> [Meal]
    func saveMealsToCache(_ meals: [Meal]) async
    func fetchFavourites() async -> [Meal]
    func toggleFavourite(mealId: String) async
    func isFavourite(mealId: String) async -> Bool
}
