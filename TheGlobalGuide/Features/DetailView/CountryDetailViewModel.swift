//
//  CountryDetailViewModel.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 06/12/25.
//
import Foundation
import UIKit
import SwiftUI
import Combine

@MainActor
class CountryDetailViewModel: ObservableObject {
    
    private let networkManager: NetworkManagerProtocol
    
    @Published var isLoading: Bool = false
    @Published var flagImage: UIImage?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchImage(imageURL: String) async {
        
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let imageData = try await networkManager.getFlagImage(for: imageURL)
            if let image = UIImage(data: imageData) {
                self.flagImage = image
            }
        } catch {
            self.flagImage = UIImage(systemName: "globe.americas")
        }
    }
}
