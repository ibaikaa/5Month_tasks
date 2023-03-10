//
//  Drinks.swift
//  cocktailsApp
//
//  Created by ibaikaa on 19/2/23.
//

import Foundation

struct DrinksList: Decodable {
    var drinks: [Drink]?
}

struct Drink: Decodable {
    let drinkName: String
    let drinkImageURLPath: String
    
    enum CodingKeys: String, CodingKey {
        case drinkName = "strDrink"
        case drinkImageURLPath = "strDrinkThumb"
    }
}
