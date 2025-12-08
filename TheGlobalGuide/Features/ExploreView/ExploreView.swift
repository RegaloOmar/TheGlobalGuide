//
//  ExploreView.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import SwiftUI

struct ExploreView: View {
    
    @ObservedObject var viewModel: CountryListViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
                case .error(let errorMessage):
                    ContentUnavailableView("Connection Error",
                                           systemImage: "wifi.exclamationmark",
                                           description: Text(errorMessage))
                case .empty(let errorMessage):
                    ContentUnavailableView.search(text: errorMessage)
                    
                case .loaded, .entry:
                    List(viewModel.filteredCountries) { country in
                        NavigationLink(destination: CountryRowDetailView(country: country,
                                                                      favoriteViewModel: viewModel)) {
                            CountryRowView(country: country, isFavorite: viewModel.isFavorite(country)) {
                                viewModel.toggleFavorite(country)
                            }
                        }
                    }
                    .listStyle(.plain)
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search a country")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Region", selection: $viewModel.selectedRegion) {
                        Text("🗺️ All").tag(Region?.none)
                        ForEach(Region.allCases) { region in
                            Text("\(region.icon) \(region.rawValue)").tag(Optional(region))
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .symbolVariant(viewModel.selectedRegion != nil ? .fill : .none)
                }
            }
        }
    }
}

#Preview {
    ExploreView(viewModel: CountryListViewModel())
}
