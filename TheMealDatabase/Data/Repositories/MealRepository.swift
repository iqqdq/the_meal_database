//
//  MealRepository.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import Foundation
import CoreData

final class MealRepository: MealRepositoryProtocol {
    
    private let apiClient: APIClient
    private let coreDataStack: CoreDataStack // TODO: Заменить на MealStorage
    
    init(
        apiClient: APIClient = .shared,
        coreDataStack: CoreDataStack = .shared
    ) {
        self.apiClient = apiClient
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Search & Network
    
    func searchMeals(query: String) async throws -> [Meal] {
        // 1. Формируем Endpoint
        let endpoint = Endpoint(
            path: "/search.php",
            queryItems: [URLQueryItem(name: "s", value: query)]
        )
        
        // 2. Скачиваем данные
        let response: MealResponse = try await apiClient.request(endpoint: endpoint)
        
        // 3. Превращаем DTO в доменные модели (если meals == nil, возвращаем пустой массив)
        guard let mealsDTO = response.meals else { return [] }
        let meals = mealsDTO.compactMap { $0.toDomain() }
        
        // 4. Сохраняем в кэш (Core Data) в фоне
        await saveMealsToCache(meals)
        
        // 5. Возвращаем результат
        return meals
    }
    
    // MARK: - Favourites & Core Data
    
    func fetchFavourites() async throws -> [Meal] {
        let context = coreDataStack.viewContext
        
        return await context.perform {
            let request = MealEntity.fetchRequest()
            // TODO:
            // Добавить предикат для избранного
            do {
                let entities = try context.fetch(request)
                return entities.compactMap { $0.toDomain() }
            } catch {
                print("❌ Failed to fetch from CoreData: \(error)")
                return []
            }
        }
    }
    
    // TODO:
    // Заглушка для получения рандомного блюда
//    func fetchRandomMeal() async throws -> Meal { }
    
    // TODO:
    // Заглушки для избранного (добавим логику позже)
    func saveFavourite(meal: Meal) async throws { }
    func removeFavourite(mealId: String) async throws { }

    
    // MARK: - Private Helpers
    
    private func saveMealsToCache(_ meals: [Meal]) async {
        let context = coreDataStack.newBackgroundContext()
        await context.perform {
            for meal in meals {
                // Проверяем, нет ли уже такого блюда в базе (чтобы не дублировать)
                let request = MealEntity.fetchRequest()
                request.predicate = NSPredicate(format: "idMeal == %@", meal.id)
                
                if let existing = try? context.fetch(request).first {
                    // Если есть — можно обновить поля (опционально)
                    existing.strMeal = meal.name
                    // Удаляем старые ингредиенты, чтобы не дублировались
                    if let ingredients = existing.ingredients as? Set<IngredientEntity> {
                        ingredients.forEach { context.delete($0) }
                    }
                    // Создаем новые
                    for ingredient in meal.ingredients {
                        let ingEntity = IngredientEntity(context: context)
                        ingEntity.name = ingredient.name
                        ingEntity.measure = ingredient.measure
                        ingEntity.meal = existing
                    }
                } else {
                    // Если нет — создаем новое через наш маппинг
                    _ = MealEntity.fromDomain(meal, context: context)
                }
            }
            
            do {
                try context.save()
                print("Saved \(meals.count) meals to cache")
            } catch {
                print("Core Data save error: \(error)")
            }
        }
    }
}
