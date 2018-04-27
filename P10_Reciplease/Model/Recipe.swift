//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//
import Foundation
import SwiftyJSON

enum RecipeType {
    case Search
    case Detail
}

///
class Recipe {
    var name: String
    var id: String
    var imageUrl: String
    var ingredients: JSON
    var ingredientList: String
    var rating: Double
    var totalTime: String?
    var largeImage = UIImage()
    var sourceRecipeUrl: String
    
    init (with json: JSON, type: RecipeType) {
        switch type {
        case .Search:
            self.name = json["recipeName"].stringValue
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
            self.sourceRecipeUrl = ""
            self.totalTime = self.convertSecondInMinute(json["totalTimeInSeconds"].stringValue)
            
        case .Detail:
            self.name = json["name"].stringValue
            self.id = ""
            self.totalTime = json["totalTime"].stringValue
            self.imageUrl = json["images"][0]["hostedLargeUrl"].stringValue
            self.imageUrl = self.imageUrl.replacingOccurrences(of: "\\", with: "")
            self.sourceRecipeUrl = json["source"]["sourceRecipeUrl"].stringValue
            self.sourceRecipeUrl = self.sourceRecipeUrl.replacingOccurrences(of: "\\", with: "")
            self.ingredients = json["ingredientLines"]
            self.ingredientList = ""
            self.rating = json["rating"].doubleValue
        }
    }
    
    func convertSecondInMinute(_ stringSecond : String) -> String {
        if let seconds = Int(stringSecond) {
            let minutes = (seconds % 3600) / 60
            
            return "\(minutes)m"
        }
        return "null"
    }
}
