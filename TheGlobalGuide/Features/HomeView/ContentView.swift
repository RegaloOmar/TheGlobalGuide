//
//  ContentView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 03/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = CountryListViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                
                Tab("Explore", systemImage: selectedTab == 0 ? "globe.americas.fill" : "globe.americas" , value: 0) {
                    NavigationStack {
                        ExploreView(viewModel: viewModel)
                            .navigationTitle("Explore the World!")
                    }
                }
                
                Tab("Favorites", systemImage: selectedTab == 1 ? "heart.fill" : "heart", value: 1) {
                    NavigationStack {
                        FavoritesView(viewModel: viewModel)
                    }
                }
                .badge(viewModel.favoriteCountries.count)
                
            }
            .tabViewStyle(.automatic)
            .tabBarMinimizeBehavior(.onScrollDown)
            .tint(.indigo)
            
            
            if viewModel.isLoading{
                LoaderView()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

#Preview("English") {
    ContentView()
}

#Preview("Español") {
    ContentView()
        .environment(\.locale, .init(identifier: "es"))
}
