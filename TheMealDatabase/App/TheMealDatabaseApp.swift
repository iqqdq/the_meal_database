//
//  TheMealDatabaseApp.swift
//  TheMealDatabase
//
//  Created by Artur on 04.11.2026.
//

import SwiftUI

@main
struct TheMealDatabaseApp: App {
    @State private var store: MealStore
    
    init() {
        let repository = MealRepository()
        _store = State(wrappedValue: MealStore(repository: repository))
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(store) // Прокидываем Store во всё приложение
                .background(Color.appBackground)
        }
    }
}
