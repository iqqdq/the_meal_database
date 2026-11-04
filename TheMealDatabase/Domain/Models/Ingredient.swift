//
//  Ingredient.swift
//  TheMealDatabase
//
//  Created by Artur on 04.11.2026.
//

import Foundation

struct Ingredient: Identifiable, Hashable {
    let id: String
    let name: String
    let measure: String?
}
