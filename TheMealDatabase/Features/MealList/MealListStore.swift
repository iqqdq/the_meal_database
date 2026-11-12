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
    
    // MARK: - Dependencies
    
    private let repository: MealRepositoryProtocol
    
    // MARK: - UI
    
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
            self.meals = try await repository.searchMeals(query: searchQuery)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
