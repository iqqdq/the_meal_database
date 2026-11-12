//
//  MealListView.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import SwiftUI

struct MealListView: View {

    // MARK: - Dependencies

    private let repository: MealRepositoryProtocol

    // MARK: - State

    @State private var store: MealListStore
    @State private var searchTask: Task<Void, Never>? = nil

    // MARK: - Init

    init(repository: MealRepositoryProtocol) {
        self.repository = repository
        _store = State(wrappedValue: MealListStore(repository: repository))
    }

    // MARK: - UI

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
                MealDetailView(meal: meal, repository: repository)
            }
        }
    }
}

#Preview {
    MealListView(repository: MockMealRepository())
}
