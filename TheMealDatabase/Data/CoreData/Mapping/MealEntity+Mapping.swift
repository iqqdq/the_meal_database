//
//  MealEntity+Mapping.swift.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import CoreData
import Foundation

extension MealEntity {
    func toDomain() -> Meal? {
        guard let id = self.idMeal, let name = self.strMeal else { return nil }

        // Достаем ингредиенты из связи (NSSet -> [IngredientEntity])
        let ingredientsArray =
            (self.ingredients as? Set<IngredientEntity>) ?? []

        // Маппим ингредиенты в доменные модели и сортируем по имени
        let mappedIngredients = ingredientsArray.compactMap { $0.toDomain() }
            .sorted { $0.name < $1.name }

        return Meal(
            id: id,
            name: name,
            category: self.strCategory,
            area: self.strArea,
            instructions: self.strInstructions,
            imageURL: self.strMealThumb,
            ingredients: mappedIngredients,
            isFavourite: self.isFavourite
        )
    }

    static func fromDomain(
        _ meal: Meal,
        context: NSManagedObjectContext
    ) -> MealEntity {
        let entity = MealEntity(context: context)
        entity.idMeal = meal.id
        entity.strMeal = meal.name
        entity.strCategory = meal.category
        entity.strArea = meal.area
        entity.strInstructions = meal.instructions
        entity.strMealThumb = meal.imageURL

        // Создаем связанные ингредиенты
        for ingredient in meal.ingredients {
            let ingredientEntity = IngredientEntity(context: context)
            ingredientEntity.name = ingredient.name
            ingredientEntity.measure = ingredient.measure

            // Связываем (Один-ко-многим)
            ingredientEntity.meal = entity
        }

        return entity
    }
}

extension IngredientEntity {
    func toDomain() -> Ingredient {
        return Ingredient(
            id: UUID().uuidString,
            name: self.name,
            measure: self.measure
        )
    }
}
