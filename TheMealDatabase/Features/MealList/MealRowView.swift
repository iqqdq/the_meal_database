//
//  MealRowView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

struct MealRowView: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 12) {
            // Image
            AsyncImage(url: URL(string: meal.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Name
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.headline)
                    .foregroundStyle(.appText)

                // Category
                if let category = meal.category {
                    Text(category)
                        .font(.subheadline)
                        .foregroundStyle(.appSecondaryText)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
