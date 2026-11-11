//
//  TheMealDatabaseApp.swift
//  TheMealDatabase
//
//  Created by Artur on 04.11.2026.
//

import SwiftUI

@main
struct TheMealDatabaseApp: App {
    let repository: MealRepositoryProtocol

    init() {
        self.repository = MealRepository()
    }

    var body: some Scene {
        WindowGroup {
            MealListView(repository: repository)
        }
    }
}
