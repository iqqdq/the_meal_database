//
//  AppRouter.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI
import Observation

/// Перечисление всех возможных маршрутов.
enum AppRoute: Hashable {
    case mealDetail(meal: Meal)
}

@MainActor
@Observable
final class AppRouter {
    var path = NavigationPath()
    
    func navigateToMealDetail(_ meal: Meal) {
        path.append(AppRoute.mealDetail(meal: meal))
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
