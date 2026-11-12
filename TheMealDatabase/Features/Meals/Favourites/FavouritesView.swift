//
//  FavouritesView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

import SwiftUI

struct FavouritesView: View {
    @Environment(MealStore.self) private var store
    
    var body: some View {
        NavigationStack {
            Group {
                if !store.hasLoadedFavourites && store.isLoading {
                    ProgressView()
                }
                else if store.favourites.isEmpty {
                    ContentUnavailableView(
                        "No favourites",
                        systemImage: "heart.slash",
                        description: Text("Add meals to favourites to see them here")
                    )
                }
                else {
                    List(store.favourites) { meal in
                        NavigationLink(value: meal) {
                            MealRowView(meal: meal)
                        }
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
