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
class SearchRecipe {
    var title: String
    var id: String
    var imageUrl: String
    var ingredients: JSON
    var ingredientList: String
    var rating: Double
    var executionTime: String?
    var category: String
    
    init (with json: JSON) {
        self.title = json["recipeName"].stringValue
        self.id = json["id"].stringValue
        self.imageUrl = json["imageUrlsBySize"]["90"].stringValue
        self.imageUrl = self.imageUrl.replacingOccurrences(of: "\\", with: "")
        self.ingredients = json["ingredients"]
        self.ingredientList = ""
        for i in 0...self.ingredients.count-1 {
            self.ingredientList += self.ingredients[i].stringValue
            if i < self.ingredients.count-1 {
                self.ingredientList += ", "
            }
        }
        
        self.rating = json["rating"].doubleValue
        self.category = json["attributes"]["course"][0].stringValue
        self.executionTime = self.convertSecondInMinute(json["totalTimeInSeconds"].stringValue)
    }
    
    func convertSecondInMinute(_ stringSecond : String) -> String {
        if let seconds = Int(stringSecond) {
            let minutes = (seconds % 3600) / 60
            
            return "\(minutes)m"
        }
        return "null"
    }
}
