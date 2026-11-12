//
//  MockPreviewMeal.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

#if DEBUG
    #Preview("Meal Detail") {
        NavigationStack {
            MealDetailView(
                meal: Meal(
                    id: "1",
                    name: "Spicy Arrabiata Penne",
                    category: "Vegetarian",
                    area: "Italian",
                    instructions:
                        "1. Bring a large pot of salted water to a boil...\n2. Add the penne and cook until al dente...",
                    imageURL:
                        "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg",
                    ingredients: [
                        Ingredient(
                            id: "1",
                            name: "penne rigate",
                            measure: "1 pound"
                        ),
                        Ingredient(
                            id: "2",
                            name: "olive oil",
                            measure: "1/4 cup"
                        ),
                        Ingredient(
                            id: "3",
                            name: "garlic",
                            measure: "3 cloves"
                        ),
                    ]
                ),
                repository: MockMealRepository()
            )
        }
    }
#endif
