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
class DetailedRecipe {
    var name: String
    var totalTime: String
    var imageUrl: String
    var largeImage = UIImage()
    var sourceRecipeUrl: String
    var ingredientLines: JSON
    var rating: Double
    
    init (with json: JSON) {
        self.name = json["name"].stringValue
        self.totalTime = json["totalTime"].stringValue
        self.imageUrl = json["images"][0]["hostedLargeUrl"].stringValue
        self.imageUrl = self.imageUrl.replacingOccurrences(of: "\\", with: "")
        self.sourceRecipeUrl = json["source"]["sourceRecipeUrl"].stringValue
        self.sourceRecipeUrl = self.sourceRecipeUrl.replacingOccurrences(of: "\\", with: "")
        self.ingredientLines = json["ingredientLines"]
        self.rating = json["rating"].doubleValue
    }
}
