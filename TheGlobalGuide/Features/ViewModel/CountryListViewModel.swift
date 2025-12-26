//
//   CountryListViewModel.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//

import Foundation
import Combine
import UIKit

enum ViewState: Equatable {
    case entry
    case loaded
    case empty(String)
    case error(String)
}

enum Region: String, CaseIterable, Identifiable {
    case africa = "Africa"
    case americas = "Americas"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
    case antarctic = "Antarctic"
    
    var id: String { self.rawValue }
    var icon: String {
        switch self {
        case .africa: return "🦁"
        case .americas: return "🌎"
        case .asia: return "⛩️"
        case .europe: return "🏰"
        case .oceania: return "🏝️"
        case .antarctic: return "❄️"
        }
    }
}

@MainActor
class CountryListViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let networkManager: NetworkManagerProtocol
    private let persistenceManager: PersistenceManagerProtocol
    
    //MARK: - Persistence
    private let favoritesKey = "saved_favorites_ids"
    @Published var favoriteCountries: [Country] = []
    
    // MARK: - Published Properties
    @Published var state: ViewState = .entry
    @Published private(set) var filteredCountries: [Country] = []
    @Published var isLoading: Bool = false
    
    // Filter & Search
    @Published var searchText: String = ""
    @Published var selectedRegion: Region? = nil
    
    // MARK: - Internal State
    private var allCountries: [Country] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol = NetworkManager(),
         persistenceManager: PersistenceManagerProtocol? = nil ) {
        self.networkManager = networkManager
        self.persistenceManager = persistenceManager ?? PersistenceManager()
        loadFavorites()
        setupSearchPipeline()
    }
    
    // MARK: - Public Methods
    
    func loadData() async {
        guard allCountries.isEmpty else { return }
        isLoading.toggle()
        
        defer { isLoading .toggle() }
        
        do {
            let countries = try await networkManager.fetchCountries()
            self.allCountries = countries.sorted { $0.commonName < $1.commonName }
            self.filteredCountries = self.allCountries
            self.state = .loaded
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Favorites Logic
    
    func toggleFavorite(_ country: Country) {
        if let index = favoriteCountries.firstIndex(where: { $0.id == country.id }) {
            favoriteCountries.remove(at: index)
        } else {
            favoriteCountries.append(country)
        }
        saveFavorites()
    }
    
    func isFavorite(_ country: Country) -> Bool {
        return favoriteCountries.contains(where: { $0.id == country.id })
    }
    
    //MARK: - Persistence Funcitons
    
    private func saveFavorites() {
        persistenceManager.save(favoriteCountries, key: favoritesKey)
    }
    
    private func loadFavorites() {
        if let savedCountries = persistenceManager.load(key: favoritesKey, as: [Country].self) {
            self.favoriteCountries = savedCountries
        } else {
            self.favoriteCountries = []
        }
    }
    
    // MARK: - Serach and filter with Combine
    private func setupSearchPipeline() {
        Publishers.CombineLatest($searchText, $selectedRegion)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] (text, region) in
                self?.applyFilters(text: text, region: region)
            }
            .store(in: &cancellables)
    }
    
    private func applyFilters(text: String, region: Region?) {
        var result = allCountries
        
        if let region = region {
            result = result.filter { $0.region == region.rawValue }
        }
        
        if !text.isEmpty {
            result = result.filter {
                $0.commonName.hasPrefix(text) ||
                $0.officialName.hasPrefix(text)
            }
        }
        
        self.filteredCountries = result
        
        if result.isEmpty && !allCountries.isEmpty {
            self.state = .empty(text)
        } else if !result.isEmpty {
            self.state = .loaded
        }
    }
}
