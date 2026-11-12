//
//  MealListView.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import SwiftUI

struct MealListView: View {
    @State private var store: MealListStore
    // Debounce task
    @State private var searchTask: Task<Void, Never>? = nil

    init(repository: MealRepositoryProtocol) {
        _store = State(wrappedValue: MealListStore(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView("Searching for recipes...").foregroundStyle(
                        .appText
                    )
                } else if let error = store.errorMessage {
                    Text("Error: \(error)")
                        .foregroundStyle(.red)
                } else if store.meals.isEmpty {
                    ContentUnavailableView(
                        "Nothing found",
                        systemImage: "fork.knife",
                        description: Text("Enter a meal name to search")
                            .font(.subheadline)
                            .foregroundStyle(.appSecondaryText)
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
            .foregroundStyle(.appText)
            .onChange(of: store.searchQuery) { _, newValue in
                // 1. Отменяем предыдущую задачу, если пользователь все еще печатает
                searchTask?.cancel()

                // 2. Создаем новую задачу
                searchTask = Task {
                    do {
                        // 3. Ждем 0.5 секунды
                        try await Task.sleep(for: .milliseconds(500))

                        // 4. Если за это время не было новых нажатий (задача не отменена), делаем запрос
                        if !Task.isCancelled {
                            await store.search()
                        }
                    } catch {
                        // Если Task.sleep был прерван (пользователь ввел новую букву),
                        // сюда прилетит ошибка CancellationError. Это нормально.
                    }
                }
            }
            .navigationDestination(for: Meal.self) { meal in
                MealDetailView(meal: meal)
            }
        }
    }
}

// MARK: - MealRowView

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

#Preview {
    MealListView(repository: MockMealRepository())
}
