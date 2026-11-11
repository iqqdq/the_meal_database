//
//  MealResponse.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import Foundation

// То, что приходит от сервера
struct MealResponse: Decodable {
    let meals: [MealDTO]?
}

struct MealDTO: Decodable {
    let idMeal: String
    let strMeal: String
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strMealThumb: String?

    // Нужно вручную распарсить до 20 ингредиентов
    var ingredients: [Ingredient] = []

    enum CodingKeys: String, CodingKey {
        case idMeal,
            strMeal,
            strCategory,
            strArea,
            strInstructions,
            strMealThumb
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decodeIfPresent(
            String.self,
            forKey: .strCategory
        )
        strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        strInstructions = try container.decodeIfPresent(
            String.self,
            forKey: .strInstructions
        )
        strMealThumb = try container.decodeIfPresent(
            String.self,
            forKey: .strMealThumb
        )

        // Динамический парсинг ингредиентов
        let dynamicContainer = try decoder.container(
            keyedBy: DynamicCodingKeys.self
        )

        for i in 1...20 {
            let ingredientKey = DynamicCodingKeys(
                stringValue: "strIngredient\(i)"
            )!
            
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")!

            if let ingredientName = try dynamicContainer.decodeIfPresent(
                String.self,
                forKey: ingredientKey
            ),
                !ingredientName.trimmingCharacters(in: .whitespaces).isEmpty
            {

                let measure = try dynamicContainer.decodeIfPresent(
                    String.self,
                    forKey: measureKey
                )

                ingredients.append(
                    Ingredient(
                        id: UUID().uuidString,
                        name: ingredientName,
                        measure: measure
                    )
                )
            }
        }
    }
}

// Вспомогательный ключ для динамического парсинга
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        return nil
    }
}

extension MealDTO {
    func toDomain() -> Meal {
        return Meal(
            id: idMeal,
            name: strMeal,
            category: strCategory,
            area: strArea,
            instructions: strInstructions,
            imageURL: strMealThumb,
            ingredients: ingredients
        )
    }
}
