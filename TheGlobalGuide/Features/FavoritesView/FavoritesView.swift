//
//  FavoritesView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: CountryListViewModel
    
    @Namespace private var animation
    
    @State private var selectedCountry: Country?
    @State private var showDetail = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            if viewModel.favoriteCountries.isEmpty {
                ContentUnavailableView("Your Album is empty :(",
                                       systemImage: "photo.stack",
                                       description: Text("Your favorites will be here...when you select it :)"))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.favoriteCountries) { country in
                            CountryCardView(country: country,
                                            animation: animation,
                                            isSource: (selectedCountry?.id != country.id) || !showDetail ) {
                                withAnimation(.spring()) {
                                    viewModel.toggleFavorite(country)
                                }
                            }
                            .opacity(showDetail ? 0 : 1)
                            .onTapGesture {
                                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1.0, blendDuration: 0.5)) {
                                    selectedCountry = country
                                    showDetail = true
                                }
                            }
                        }
                    }
                    .padding()
                    .zIndex(1)
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .navigationTitle(selectedCountry == nil ? "My Favorites" : "")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(selectedCountry != nil ? .hidden : .visible, for: .tabBar)
                
            }
            
            if let country = selectedCountry, showDetail {
                ZStack {
                    CountryCardDetailView(country: country,
                                      animation: animation,
                                      onClose: {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1.0, blendDuration: 0.5)) {
                            showDetail = false
                            selectedCountry = nil
                        }
                    })
                }
                .zIndex(2)
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: CountryListViewModel())
}
