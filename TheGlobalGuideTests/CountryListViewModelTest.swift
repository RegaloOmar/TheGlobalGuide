//
//  CountryListViewModelTest.swift
//  TheGlobalGuideTests
//
//  Created by Omar Regalado Mendoza on 23/12/25.
//

import XCTest
import Combine
@testable import TheGlobalGuide

@MainActor
final class CountryListViewModelTests: XCTestCase {
    
    var viewModel: CountryListViewModel!
    var mockNetwork: MockNetworkManager!
    var mockPersistence: MockPersistenceManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        mockPersistence = MockPersistenceManager()
        cancellables = []
        viewModel = CountryListViewModel(networkManager: mockNetwork, persistenceManager: mockPersistence)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        mockPersistence = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Load Data Test
    
    func testLoadData_Success() async {
        let country = Country.mock(id: "MX", name: "Mexico")
        mockNetwork.mockCountries = [country]
        
        await viewModel.loadData()
        
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.commonName, "Mexico")
    }
    
    func testLoadData_Error() async {

        mockNetwork.shouldReturnError = true
        
        await viewModel.loadData()
        
        if case .error = viewModel.state {
            XCTAssertTrue(true) 
        } else {
            XCTFail("State should be error")
        }
    }
    
    // MARK: - Test Favorites & Persistence
    
    func testToggleFavorite_SavesToPersistence() {
        let country = Country.mock(id: "MX", name: "Mexico")
        
        viewModel.toggleFavorite(country)
        
        XCTAssertTrue(viewModel.isFavorite(country))
        XCTAssertTrue(mockPersistence.saveCalled, "Save is called")
    }
    
    func testInit_LoadsFavoritesFromPersistence() {
        let savedCountry = Country.mock(id: "CA", name: "Canada")
        
        mockPersistence.mockLoadResult = [savedCountry]

        XCTAssertTrue(mockPersistence.loadCalled, "Persisntence Load function was called at viewmodel init")
        XCTAssertFalse(mockPersistence.saveCalled, "Save function was never called")
    }
    
    // MARK: - Search Tests
    
    func testSearch_FiltersCorrectly() async {
        
        let c1 = Country.mock(id: "US", name: "United States of America")
        let c2 = Country.mock(id: "UK", name: "United Kingdom")
        let c3 = Country.mock(id: "UAE", name: "United Arab Emirates")
        
        mockNetwork.mockCountries = [c1, c2, c3]
        
        await viewModel.loadData()
        
        let expectation = XCTestExpectation(description: "Wait for search debounce")
        
        viewModel.searchText = "United K"
        
        viewModel.$filteredCountries
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.commonName, "United Kingdom")
    }
    
    func testSearchWithNoMatches_ShouldSetEmptyState() async {

        let country = Country.mock(id: "SWE", name: "Sweden")
        
        mockNetwork.mockCountries = [country]
        
        await viewModel.loadData()
        
        let expectation = XCTestExpectation(description: "Wait for debounce")
        
        viewModel.searchText = "Wakanda"
        
        viewModel.$state
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.filteredCountries.count, 0)
        if case .empty(let query) = viewModel.state {
            XCTAssertEqual(query, "Wakanda")
        } else {
            XCTFail("State should be empty")
        }
    }
    
    func testClearSearchText_ShouldShowAllCountries() async {
        
        let mexico = Country.mock(id: "MEX", name: "Mexico")
        let usa = Country.mock(id: "USA", name: "United States of America")
        
        mockNetwork.mockCountries = [mexico, usa]
        
        await viewModel.loadData()
        
        viewModel.searchText = "Mex"
        try? await Task.sleep(for: .seconds(0.5))
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        
        viewModel.searchText = ""
        try? await Task.sleep(for: .seconds(0.5))
        
        XCTAssertEqual(viewModel.filteredCountries.count, 2)
        XCTAssertEqual(viewModel.state, .loaded)
    }
    
    
    //MARK: - Test Search & Filter
    func testFilterAndSerach_Combined() async {
        
        let brazil = Country.mock(id: "BRA", name: "Brazil", region: "Americas")
        let spain = Country.mock(id: "SPA", name: "Spain", region: "Europe")
        
        mockNetwork.mockCountries = [brazil, spain]
        
        await viewModel.loadData()
        
        viewModel.selectedRegion = .europe
        viewModel.searchText = "Brazil"
        
        try? await Task.sleep(for: .seconds(0.5))
        
        XCTAssertEqual(viewModel.filteredCountries.count, 0)
    }
}
