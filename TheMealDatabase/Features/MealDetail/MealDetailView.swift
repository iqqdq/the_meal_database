//
//  MealDetailView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 16.0
            ) {
                // Image
                AsyncImage(
                    url: URL(string: meal.imageURL ?? "")
                ) {
                    image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250.0)
                .clipped()

                VStack(
                    alignment: .leading,
                    spacing: 16.0
                ) {
                    // Name
                    Text(meal.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.appText)

                    HStack {
                        // Category
                        if let category = meal.category {
                            Label(category, systemImage: "fork.knife")
                                .font(.subheadline)
                                .foregroundStyle(.appSecondaryText)
                        }
                        Spacer()
                        // Area
                        if let area = meal.area {
                            Label(area, systemImage: "globe")
                                .font(.subheadline)
                                .foregroundStyle(.appSecondaryText)
                        }
                    }

                    Divider()

                    // Indigrients
                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.appText)

                    ForEach(
                        meal.ingredients
                    ) { ingredient in
                        HStack {
                            Text(ingredient.name)
                                .foregroundStyle(.appText)
                            Spacer()
                            Text(ingredient.measure ?? "")
                                .foregroundStyle(.appSecondaryText)
                        }
                    }.padding(.vertical, 2.0)

                    Divider()

                    // Instruction
                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(
                        meal.instructions
                            ?? String(localized: "No instructions available")
                    )
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundStyle(.appSecondaryText)

                }.padding(.horizontal)
            }
        }
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
