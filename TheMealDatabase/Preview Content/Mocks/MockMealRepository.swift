//
//  MockPreviewRepository.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import Foundation

final class MockMealRepository: MealRepositoryProtocol {
    func searchMeals(query: String) async throws -> [Meal] {
        return [
            Meal(
                id: "1",
                name: "Spicy Arrabiata Penne",
                category: "Vegetarian",
                area: "Italian",
                instructions: "...",
                imageURL:
                    "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg",
                ingredients: [
                    Ingredient(id: "1", name: "Penne", measure: "1 pound"),
                    Ingredient(id: "2", name: "Olive Oil", measure: "1/4 cup"),
                ]
            ),
            Meal(
                id: "2",
                name: "Chicken Handi",
                category: "Chicken",
                area: "Indian",
                instructions: "...",
                imageURL:
                    "https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg",
                ingredients: []
            ),
        ]
    }

    func fetchFavourites() async throws -> [Meal] { return [] }
    func saveFavourite(meal: Meal) async throws {}
    func removeFavourite(mealId: String) async throws {}
}
