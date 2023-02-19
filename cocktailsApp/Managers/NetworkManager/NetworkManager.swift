//
//  NetworkManager.swift
//  cocktailsApp
//
//  Created by ibaikaa on 19/2/23.
//
import Alamofire

enum ApiType {
    case fetchDrinksByName, fetchDrinksByLetter
    
    var baseURL: String {
        "www.thecocktaildb.com"
    }
    
    var path: String {
        switch self {
        case .fetchDrinksByName: return "/api/json/v1/1/search.php/search.php"
        case .fetchDrinksByLetter: return "/api/json/v1/1/search.php/search.php"
        }
    }
    
    var parameterKeys: String {
        switch self {
        case .fetchDrinksByName: return "s"
        case .fetchDrinksByLetter: return "f"
        }
    }
    
    var components: URLComponents  {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.baseURL
        components.path = self.path
        return components
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session = URLSession(configuration: .default)
    
    private init () { }
    
    private func decode<T: Decodable>(from data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
    
    private func generateURLForApiType(_ apiType: ApiType, paramsValue: String) -> URL? {
        var components = apiType.components
        components.queryItems = [
            .init(name: apiType.parameterKeys, value: paramsValue)
        ]
        return components.url
    }
    
    public func getCocktailsWithLetter(_ letter: String) async throws -> DrinksList {
        guard let url = generateURLForApiType(
            .fetchDrinksByLetter,
            paramsValue: letter
        ) else {
            print("Network Manager Error. URL is nil in getCocktailsWithLetter(_ letter: String)  method. Returning empty object.")
            return DrinksList()
        }
        print("URL for letter \"\(letter)\" is: \(url)")
        let (data, _) =  try await session.data(from: url)
        return try decode(from: data)
    }
    
    public func getCocktailsWithName(_ name: String) async throws -> DrinksList {
        guard let url = generateURLForApiType(
            .fetchDrinksByName,
            paramsValue: name
        ) else {
            print("Network Manager Error. URL is nil in getCocktailsWithName(_ name: String) method. Returning empty object.")
            return DrinksList()
        }
        print("URL for name \"\(name)\" is: \(url)")
        let (data, _) =  try await session.data(from: url)
        return try decode(from: data)
    }
}
