//
//  FlagImageViewModelTest.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 25/12/25.
//
import XCTest
@testable import TheGlobalGuide

@MainActor
final class FlagImageViewModelTests: XCTestCase {
    
    var viewModel: FlagImageViewModel!
    var mockNetwork: MockNetworkManager!
    var mockCache: MockImageCacheManager!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkManager()
        mockCache = MockImageCacheManager()
        viewModel = FlagImageViewModel(networkManager: mockNetwork, imageCache: mockCache)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        mockCache = nil
        super.tearDown()
    }
    
    func testLoadImage_WhenCached_ShouldNotCallNetwork() async {
        
        let countryID = "MX"
        let cachedImage = UIImage(systemName: "star.fill")!.pngData()!
        mockCache.store[countryID] = cachedImage
        
        await viewModel.loadImage(from: "https://fake.url", countryId: countryID)
        
        XCTAssertNotNil(viewModel.image, "Image is filled")
        XCTAssertTrue(mockCache.loadCalled, "load function called")
    }
    
    func testLoadImage_WhenNotCached_ShouldDownloadAndSave() async {
        
        let countryID = "JP"
        let networkImage = UIImage(systemName: "circle.fill")!.pngData()!
        mockNetwork.mockFlagData = networkImage
        
        await viewModel.loadImage(from: "https://fake.url", countryId: countryID)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertTrue(mockCache.loadCalled, "Cache was called first")
        XCTAssertTrue(mockCache.saveCalled, "Image should be saved")
        XCTAssertNotNil(mockCache.store[countryID], "The file is in the cache")
    }
    
    func testLoadImage_NetworkError_ShouldShowPlaceholder() async {
        
        mockNetwork.shouldReturnError = true
        
        await viewModel.loadImage(from: "https://fake.url", countryId: "ERR")
        
        XCTAssertNotNil(viewModel.image)
    }
}
