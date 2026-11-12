//
//  IEntity+Mapping.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import Foundation

extension IngredientEntity {
    func toDomain() -> Ingredient {
        return Ingredient(
            id: UUID().uuidString,
            name: self.name,
            measure: self.measure
        )
    }
}
