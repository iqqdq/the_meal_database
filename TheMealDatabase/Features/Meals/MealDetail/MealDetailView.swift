//
//  MealDetailView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI
import Kingfisher

struct MealDetailView: View {
    
    // MARK: - Dependencies
    
    @Environment(MealStore.self) private var store
    
    // MARK: - Input
    
    let meal: Meal
    
    // Берем актуальное состояние блюда из Store,
    // чтобы лайк перекрашивался мгновенно
    private var currentMeal: Meal {
        store.getMeal(byId: meal.id) ?? meal
    }
    
    // MARK: - UI
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 16.0
            ) {
                // Image
                KFImage(URL(string: currentMeal.imageURL ?? ""))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250.0)
                    .clipped()

                VStack(
                    alignment: .leading,
                    spacing: 16.0
                ) {
                    // Name
                    Text(currentMeal.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.appText)

                    HStack {
                        // Category
                        if let category = currentMeal.category {
                            Label(category, systemImage: "fork.knife")
                                .font(.subheadline)
                                .foregroundStyle(.appSecondaryText)
                        }
                        Spacer()
                        // Area
                        if let area = currentMeal.area {
                            Label(area, systemImage: "globe")
                                .font(.subheadline)
                                .foregroundStyle(.appSecondaryText)
                        }
                    }

                    Divider()

                    // Ingredients
                    Text("Ingredients")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.appText)

                    ForEach(currentMeal.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name)
                                .foregroundStyle(.appText)
                            Spacer()
                            Text(ingredient.measure ?? "")
                                .foregroundStyle(.appSecondaryText)
                        }
                    }
                    .padding(.vertical, 2.0)

                    Divider()

                    // Instruction
                    Text("Instructions")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.appText)

                    Text(
                        currentMeal.instructions
                            ?? String(localized: "No instructions available")
                    )
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundStyle(.appSecondaryText)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(currentMeal.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await store.toggleFavourite(meal: currentMeal)
                    }
                } label: {
                    Image(
                        systemName: currentMeal.isFavourite ? "heart.fill" : "heart"
                    )
                    .foregroundColor(currentMeal.isFavourite ? .red : .appText)
                }
            }
        }
    }
}
