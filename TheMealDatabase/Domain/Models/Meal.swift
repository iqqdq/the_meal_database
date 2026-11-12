//
//  Meal.swift
//  TheMealDatabase
//
//  Created by Artur on 04.11.2026.
//

import Foundation

struct Meal: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let imageURL: String?
    var ingredients: [Ingredient]
    var isFavourite: Bool = false
}
