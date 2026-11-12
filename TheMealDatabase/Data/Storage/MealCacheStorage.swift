//
//  MealCacheStorage.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import CoreData
import Foundation

final class MealCacheStorage: MealCacheStorageProtocol {
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = .shared) {
        self.coreDataStack = coreDataStack
    }
    
    func saveMealsToCache(_ meals: [Meal]) async {
        let context = coreDataStack.newBackgroundContext()
        await context.perform {
            for meal in meals {
                let request = MealEntity.fetchRequest()
                request.predicate = NSPredicate(format: "idMeal == %@", meal.id)

                if let existing = try? context.fetch(request).first {
                    // Обновляем поля, не трогая isFavourite
                    existing.strMeal = meal.name
                    existing.strCategory = meal.category
                    existing.strArea = meal.area
                    existing.strInstructions = meal.instructions
                    existing.strMealThumb = meal.imageURL

                    // Обновляем ингредиенты
                    if let ingredients = existing.ingredients as? Set<IngredientEntity> {
                        ingredients.forEach { context.delete($0) }
                    }
                    for ingredient in meal.ingredients {
                        let ingEntity = IngredientEntity(context: context)
                        ingEntity.name = ingredient.name
                        ingEntity.measure = ingredient.measure
                        ingEntity.meal = existing
                    }
                } else {
                    _ = MealEntity.fromDomain(meal, context: context)
                }
            }
            try? context.save()
        }
    }

    func fetchFavourites() async -> [Meal] {
        let context = coreDataStack.viewContext
        return await context.perform {
            let request = MealEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isFavourite == YES")
            let entities = (try? context.fetch(request)) ?? []
            return entities.compactMap { $0.toDomain() }
        }
    }

    func toggleFavourite(mealId: String) async {
        let context = coreDataStack.newBackgroundContext()
        await context.perform {
            let request = MealEntity.fetchRequest()
            request.predicate = NSPredicate(format: "idMeal == %@", mealId)
            if let entity = try? context.fetch(request).first {
                entity.isFavourite.toggle()
                try? context.save()
            }
        }
    }
    
    // Реализуйте searchFromCache и isFavourite аналогично
    func searchFromCache(query: String) async -> [Meal] {
        // Логика поиска в Core Data по названию
        return []
    }
    
    func isFavourite(mealId: String) async -> Bool {
        // Логика проверки, лайкнуто ли блюдо
        return false
    }
}
