//
//  MainViewModel.swift
//  cocktailsApp
//
//  Created by ibaikaa on 19/2/23.
//

import Foundation

protocol MainViewModelType {
    func getDrinksForLetter(_ letter: String) async throws -> DrinksList
    func getDrinksByName(_ name: String) -> DrinksList
}

final public class MainViewModel: MainViewModelType {
    private var networkManager: NetworkManager
    
    init() { self.networkManager = NetworkManager.shared }
    
    func getDrinksForLetter(_ letter: String) async throws -> DrinksList {
        try await networkManager.getCocktails(for: letter)
    }
    
    func getDrinksByName(_ name: String) -> DrinksList {
//        NetworkManager.shared.getCocktails(for: name)
        DrinksList()
    }
}
