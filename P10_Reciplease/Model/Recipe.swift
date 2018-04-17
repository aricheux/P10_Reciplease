//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//
import Foundation
import SwiftyJSON

///
class Recipe {
    var title: String
    var image = UIImage()
    var ingredients: String
    var rating: String
    var executionTime: String
    
    /// Initialize the weather object with Json value from Yahoo
    ///
    /// - Parameter json: Json data from yahoo
    init (with json: JSON) {
        self.title = json["recipeName"].stringValue
        
        self.ingredients = ""
        for ingredientList in json["ingredients"].arrayValue {
            self.ingredients += ingredientList.stringValue + " ,"
        }
        
        self.rating = json["rating"].stringValue
        self.executionTime = json["recipeName"].stringValue
    }
}
