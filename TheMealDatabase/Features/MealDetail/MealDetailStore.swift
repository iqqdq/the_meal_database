//
//  MealDetailStore.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import Observation

@MainActor
@Observable
final class MealDetailStore {

    // MARK: - Dependencies

    private let repository: MealRepositoryProtocol
    
    // MARK: - Input
    
    let meal: Meal

    // MARK: - State

    var isFavourite: Bool

    // MARK: - Init

    init(meal: Meal, repository: MealRepositoryProtocol) {
        self.meal = meal
        self.repository = repository
        self.isFavourite = meal.isFavourite
    }

    func toggleFavourite() async {
        // 1. Мгновенно меняем UI
        isFavourite.toggle()

        // 2. Сохраняем в базу
        do {
            try await repository.toggleFavourite(meal: meal)
        } catch {
            // Если ошибка — откатываем назад
            isFavourite.toggle()
            print("Ошибка лайка: \(error)")
        }
    }
}
