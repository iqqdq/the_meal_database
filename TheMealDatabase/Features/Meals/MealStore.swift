//
//  MealStore.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MealStore {
    
    // MARK: - Dependencies
    
    private let repository: MealRepositoryProtocol
    
    // MARK: - State
    
    var meals: [Meal] = []
    var favourites: [Meal] = []
    
    var isLoading = false
    var errorMessage: String?
    var searchQuery = ""
    var hasLoadedFavourites = false
    
    // MARK: - Init
    
    init(repository: MealRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Helpers
    
    // Находит актуальное состояние блюда (для обновления UI деталей)
    func getMeal(byId id: String) -> Meal? {
        return meals.first(where: { $0.id == id })
            ?? favourites.first(where: { $0.id == id })
    }
}

// MARK: - Extension: Search

extension MealStore {
    func search() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            meals = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedMeals = try await repository.searchMeals(query: searchQuery)
            self.meals = fetchedMeals
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}


// MARK: - Extension: Favourites

extension MealStore {
    func loadFavourites() async {
        if !hasLoadedFavourites {
            isLoading = true
        }
        
        errorMessage = nil
        
        do {
            self.favourites = try await repository.fetchFavourites()
            self.hasLoadedFavourites = true // Запоминаем, что успешно загрузили
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func toggleFavourite(meal: Meal) async {
        // 1. Мгновенно обновляем UI
        updateFavouriteState(mealId: meal.id)
        
        // 2. Сохраняем в базу
        do {
            try await repository.toggleFavourite(meal: meal)
            
            // 3. Синхронизируем массив избранного (чтобы он появился/исчез на вкладке)
            await loadFavourites()
        } catch {
            // Если ошибка — откатываем назад
            updateFavouriteState(mealId: meal.id)
            print("Ошибка лайка: \(error)")
        }
    }
    
    // Приватный хелпер для обновления статуса в обоих массивах
    private func updateFavouriteState(mealId: String) {
        if let index = meals.firstIndex(where: { $0.id == mealId }) {
            meals[index].isFavourite.toggle()
        }
        if let index = favourites.firstIndex(where: { $0.id == mealId }) {
            favourites[index].isFavourite.toggle()
        }
    }
}
