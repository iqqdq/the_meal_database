//
//  MealListView.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//
import SwiftUI

struct MealListView: View {
    // Берем глобальный Store из Environment
    @Environment(MealStore.self) private var store
    
    @State private var searchTask: Task<Void, Never>? = nil
    
    var body: some View {
        // Чтобы делать Binding к searchQuery из @Environment, используем @Bindable
        @Bindable var store = store
        
        NavigationStack {
            Group {
                if store.isLoading && store.meals.isEmpty {
                    ProgressView("Searching for recipes...")
                } else if let error = store.errorMessage {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                } else if store.meals.isEmpty {
                    ContentUnavailableView(
                        "Nothing found",
                        systemImage: "fork.knife",
                        description: Text("Enter a meal name to search")
                    )
                } else {
                    List(store.meals) { meal in
                        NavigationLink(value: meal) {
                            MealRowView(meal: meal)
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $store.searchQuery, prompt: "Search for a meal")
            .onChange(of: store.searchQuery) { _, _ in
                searchTask?.cancel()
                searchTask = Task {
                    do {
                        try await Task.sleep(for: .milliseconds(500))
                        if !Task.isCancelled {
                            await store.search()
                        }
                    } catch {}
                }
            }
            .navigationDestination(for: Meal.self) { meal in
                // Передаем только ID или само блюдо, репозиторий не нужен
                MealDetailView(meal: meal)
            }
        }
    }
}

#Preview {
    MealListView()
}
