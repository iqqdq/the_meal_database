//
//  FavouritesView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

struct FavouritesView: View {
    @Environment(\.appRouter) private var router
    @Environment(MealStore.self) private var store

    var body: some View {
        @Bindable var router = router

        NavigationStack(path: $router.path) {
            Group {
                if !store.hasLoadedFavourites && store.isLoading {
                    ProgressView()
                } else if store.favourites.isEmpty {
                    ContentUnavailableView(
                        "No favourites",
                        systemImage: "heart.slash",
                        description: Text(
                            "Add meals to favourites to see them here"
                        )
                    )
                } else {
                    List(store.favourites) { meal in
                        Button {
                            router.navigateToMealDetail(meal)
                        } label: {
                            MealRowView(meal: meal)
                        }
                        .foregroundStyle(.appText)
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationDestination(for: Meal.self) { meal in
                MealDetailView(meal: meal)
            }
            .task {
                await store.loadFavourites()
            }
        }
    }
}
