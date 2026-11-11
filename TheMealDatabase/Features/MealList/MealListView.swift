//
//  MealListView.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import SwiftUI

struct MealListView: View {

    // Создаем Store через @State
    @State private var store: MealListStore

    // Добавляем Store для debounce (он будет хранить текущую задачу)
    @State private var searchTask: Task<Void, Never>? = nil

    init(repository: MealRepositoryProtocol) {
        _store = State(wrappedValue: MealListStore(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.isLoading {
                    ProgressView("Ищем рецепты...")
                } else if let error = store.errorMessage {
                    Text("Ошибка: \(error)")
                        .foregroundColor(.red)
                } else if store.meals.isEmpty {
                    ContentUnavailableView(
                        "Ничего не найдено",
                        systemImage: "fork.knife",
                        description: Text("Введите название блюда для поиска")
                    )
                } else {
                    List(store.meals) { meal in
                        NavigationLink(value: meal) {
                            MealRowView(meal: meal)
                        }
                    }
                }
            }
            .navigationTitle("Рецепты")
            .searchable(text: $store.searchQuery, prompt: "Найти блюдо")
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
                // Здесь будет экран деталей (пока просто заглушка)
                Text(meal.name)
            }
        }
    }
}

// MARK: - MealRowView
// Отдельная строка списка (чтобы не захламлять основной View)
struct MealRowView: View {
    let meal: Meal

    var body: some View {
        HStack(spacing: 12) {
            // Асинхронная загрузка картинки
            AsyncImage(url: URL(string: meal.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.headline)

                if let category = meal.category {
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MealListView(repository: MockPreviewRepository())
}
