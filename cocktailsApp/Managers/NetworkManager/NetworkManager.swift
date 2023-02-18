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
        "https://www.thecocktaildb.com"
    }
    
    var path: String {
        switch self {
        case .fetchDrinksByName: return "/api/json/v1/1/search.php/search.php"
        case .fetchDrinksByLetter: return "/api/json/v1/1/search.php/search.php"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .fetchDrinksByName: return ["s": "a"]
        case .fetchDrinksByLetter: return ["f": "a"]
        }
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
    
    private init () { }
    
    public func getCocktails() -> DrinksList {
        let urlPath = ApiType.fetchDrinksByLetter.fullPath
        let params = ApiType.fetchDrinksByLetter.parameters
        var drinksList = DrinksList()
        AF.request(urlPath, parameters: params)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DrinksList.self) { response in
                switch response.result {
                case .success(let model):
                    drinksList = model
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        return drinksList
    }
}
