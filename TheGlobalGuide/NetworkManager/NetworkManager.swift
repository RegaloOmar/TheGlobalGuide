//
//  NetworkManager.swift
//  TheGlobalGuide
//
//  Created by Omar Regalado Mendoza on 05/12/25.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidURL: 
                return "Invalid url."
            case .serverError(let code):
                return "Server Error Code: \(code)"
            case .decodingError(let error):
                return "Decoding process error: \(error.localizedDescription)"
            case .unknown(let error):
                return "Unknown Error: \(error.localizedDescription)"
        }
    }
}

protocol NetworkManagerProtocol {
    func fetchCountries() async throws -> [Country]
    func getFlagImage(for urlString: String) async throws -> Data
}

class NetworkManager: NetworkManagerProtocol {
    
    
    private let baseURL = "https://restcountries.com/v3.1"
    
    nonisolated init() { }
    
    
    func fetchCountries() async throws -> [Country] {
        
        guard var components = URLComponents(string: "\(baseURL)/all") else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: "name,capital,flags,population,region,currencies,languages,timezones,cca3,latlng")
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        
        return try await performRequest(url: url)
    }
    
    func getFlagImage(for urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
            
        } catch let error as NetworkError {
            throw error
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    
}
