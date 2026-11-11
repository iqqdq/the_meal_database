//
//  MealListStore.swift
//  TheMealDatabase
//
//  Created by Artur on 11.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MealListStore {
    
    // Зависимость от протокола (как мы и договаривались)
    private let repository: MealRepositoryProtocol
    
    // Состояния для UI
    var meals: [Meal] = []
    var isLoading = false
    var errorMessage: String?
    var searchQuery = ""
    
    init(repository: MealRepositoryProtocol) {
        self.repository = repository
    }
    
    func search() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            meals = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Асинхронный вызов репозитория
            self.meals = try await repository.searchMeals(query: searchQuery)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
