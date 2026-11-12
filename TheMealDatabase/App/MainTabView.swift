//
//  MainTabView.swift
//  TheMealDatabase
//
//  Created by Artur on 12.11.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MealListView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
        }
    }
}
