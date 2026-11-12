//
//  MealRepositoryProtocol.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import Foundation

protocol MealRepositoryProtocol {
    func searchMeals(query: String) async throws -> [Meal]
    // TODO:
//    func fetchRandomMeal() async throws -> Meal
    func saveFavourite(meal: Meal) async throws
    func removeFavourite(mealId: String) async throws
    func fetchFavourites() async throws -> [Meal]
    func toggleFavourite(meal: Meal) async throws 
}
