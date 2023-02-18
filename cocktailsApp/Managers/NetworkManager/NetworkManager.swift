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
    
    var fullPath: String {
        switch self {
        case .fetchDrinksByName: return baseURL + path
        case .fetchDrinksByLetter: return baseURL + path
        }
    }
    
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session = URLSession(configuration: .default)
    
    private init () { }
    
    public func getCocktails(for letter: String) async throws -> DrinksList {
        var components = ApiType.fetchDrinksByLetter.components
        components.queryItems = [
            .init(
                name: ApiType.fetchDrinksByLetter.parameterKeys,
                value: letter
            )
        ]
        guard let url = components.url else {
            print("Couldn't create url from components. Returning empty array. Network Manager GetCocktails(for letter: String) method.")
            return DrinksList()
        }
        print(url)
        let (data, _) = try await session.data(from: url)
        return try decode(from: data)
    }
    
    private func decode<T: Decodable>(from data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
