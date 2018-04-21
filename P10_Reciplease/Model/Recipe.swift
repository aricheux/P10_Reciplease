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
    var imageUrl: String
    var ingredients: JSON
    var ingredientList: String
    var rating: Double
    var executionTime: String?
    
    /// Initialize the weather object with Json value from Yahoo
    ///
    /// - Parameter json: Json data from yahoo
    init() {
        self.title = ""
        self.imageUrl = ""
        self.ingredients = JSON()
        self.ingredientList = ""
        self.rating = 0.0
        self.executionTime = ""
    }
    
    init (with json: JSON) {
        self.title = json["sourceDisplayName"].stringValue
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
