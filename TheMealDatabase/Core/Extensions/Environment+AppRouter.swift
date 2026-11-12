//
//  Environment+AppRouter.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

private struct AppRouterKey: EnvironmentKey {
    static let defaultValue = AppRouter()
}

extension EnvironmentValues {
    var appRouter: AppRouter {
        get {
            self[AppRouterKey.self]
        }
        
        set {
            self[AppRouterKey.self] = newValue
        }
    }
}
