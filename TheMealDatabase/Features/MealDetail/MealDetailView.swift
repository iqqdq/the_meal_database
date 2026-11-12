//
//  MealDetailView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

struct MealDetailView: View {

    // MARK: - State

    @State private var store: MealDetailStore

    // MARK: - Init
    
    init(meal: Meal, repository: MealRepositoryProtocol) {
        _store = State(
            wrappedValue: MealDetailStore(meal: meal, repository: repository)
        )
    }

    // MARK: - UI
    
    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 16.0
            ) {
                // Image
                AsyncImage(
                    url: URL(string: store.meal.imageURL ?? "")
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
                    Text(store.meal.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.appText)

                    HStack {
                        // Category
                        if let category = store.meal.category {
                            Label(category, systemImage: "fork.knife")
                                .font(.subheadline)
                                .foregroundStyle(.appSecondaryText)
                        }
                        Spacer()
                        // Area
                        if let area = store.meal.area {
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
                        store.meal.ingredients
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
                        store.meal.instructions
                            ?? String(localized: "No instructions available")
                    )
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundStyle(.appSecondaryText)

                }.padding(.horizontal)
            }
        }
        .navigationTitle(store.meal.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await store.toggleFavourite()
                    }
                } label: {
                    Image(
                        systemName: store.isFavourite ? "heart.fill" : "heart"
                    )
                    .foregroundColor(store.isFavourite ? .red : .appText)
                }
            }
        }
    }

}
