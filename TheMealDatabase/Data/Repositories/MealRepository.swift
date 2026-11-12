//
//  MealRepository.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import CoreData
import Foundation

final class MealRepository: MealRepositoryProtocol {
    private let apiClient: APIClient
    private let cacheStorage: MealCacheStorageProtocol
    
    init(
        apiClient: APIClient = .shared,
        cacheStorage: MealCacheStorageProtocol = MealCacheStorage()
    ) {
        self.apiClient = apiClient
        self.cacheStorage = cacheStorage
    }
    
    func searchMeals(query: String) async throws -> [Meal] {
        // 1. Идем в сеть
        let endpoint = Endpoint(
            path: "/search.php",
            queryItems: [URLQueryItem(name: "s", value: query)]
        )
        
        let response: MealResponse = try await apiClient.request(endpoint: endpoint)
        guard let mealsDTO = response.meals else { return [] }
        let meals = mealsDTO.compactMap { $0.toDomain() }
        
        // 2. Отдаем в Storage для сохранения
        await cacheStorage.saveMealsToCache(meals)
        
        // 3. Возвращаем результат
        return meals
    }
    
    func fetchFavourites() async throws -> [Meal] {
        return await cacheStorage.fetchFavourites()
    }
    
    func toggleFavourite(meal: Meal) async throws {
        await cacheStorage.toggleFavourite(mealId: meal.id)
    }
    
    // TODO:
    
    func saveFavourite(meal: Meal) async throws {
        
    }
    
    func removeFavourite(mealId: String) async throws {
        
    }
}
