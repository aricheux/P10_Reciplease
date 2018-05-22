//
//  Recipe.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//
import Foundation
import SwiftyJSON
import CoreData

/// Class to handle the recipe from Yummly
class Recipe {
    /// A string who contain the name of the recipe
    var name: String
    /// A string who contain the id of the recipe
    var id: String
    /// A string who contain the url of the image description
    var imageUrl: String
    /// An array of string who contain all ingredient to make the recipe
    var ingredientLines: [String]
    /// A string who contain all ingredients in one line
    var ingredientList: String
    /// A double who contain the number of stars
    var rating: Double
    /// A string who contain the total time to make the recipe
    var totalTime: String
    /// An UIImage who contain the small image decription
    var smallImage: UIImage
    /// An UIImage who contain the large image description
    var largeImage: UIImage
    /// A string who contain the url of the website
    var sourceRecipeUrl: String
    /// A string who contain the number of portion
    var serving: String
    
    /// Initial the class with default value
    init() {
        self.name = ""
        self.id = ""
        self.imageUrl = ""
        self.ingredientLines = []
        self.ingredientList = ""
        self.rating = 0.0
        self.totalTime = ""
        self.smallImage = UIImage()
        self.largeImage = UIImage()
        self.sourceRecipeUrl = ""
        self.serving = ""
    }
    
    /// Initialize all search attributs with the JSON
    ///
    /// - Parameters:
    ///   - json: JSON data from the search request
    ///   - completion: status to know if the request is success
    func getSearchData(with json: JSON, completion: @escaping (Bool) -> ()) {
        self.name = json["recipeName"].stringValue
        self.id = json["id"].stringValue
        self.imageUrl = json["imageUrlsBySize"]["90"].stringValue
        self.imageUrl = self.imageUrl.replacingOccurrences(of: "\\", with: "")
        
        let ingredientArray = json["ingredients"].arrayValue
        self.ingredientList = ""
        for i in 0...ingredientArray.count-1 {
            self.ingredientList += ingredientArray[i].stringValue
            if i < ingredientArray.count-1 {
                self.ingredientList += ", "
            }
        }
        
        self.rating = json["rating"].doubleValue
        let secondTime = json["totalTimeInSeconds"].intValue
        if secondTime > 0 {
            let minute = (secondTime % 3600) / 60
            self.totalTime = "\(minute) min"
        } else {
            self.totalTime = "n/d"
        }
        
        self.sourceRecipeUrl = ""
        
        RecipeManager.sharedInstance.getRecipeImage(from: self.imageUrl){ (image, error) in
            if error == nil {
                self.smallImage = image
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    /// Initialize all detail attributs with the JSON
    ///
    /// - Parameters:
    ///   - json: JSON data from the detail request
    ///   - completion: status to know if the request is success
    func getDetailData(with json: JSON, completion: @escaping (Bool) -> ()) {
        self.imageUrl = json["images"][0]["hostedLargeUrl"].stringValue
        self.imageUrl = self.imageUrl.replacingOccurrences(of: "\\", with: "")
        let numberOfServings = json["numberOfServings"].stringValue
        self.serving = numberOfServings + " servings"
        self.sourceRecipeUrl = json["source"]["sourceRecipeUrl"].stringValue
        self.sourceRecipeUrl = self.sourceRecipeUrl.replacingOccurrences(of: "\\", with: "")
        
        self.ingredientLines = json["ingredientLines"].arrayObject as! [String]
        
        if !self.imageUrl.isEmpty {
            RecipeManager.sharedInstance.getRecipeImage(from: self.imageUrl){ (image, error) in
                if error == nil {
                    self.largeImage = image
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    /// Get all attributs from the core data recipe
    ///
    /// - Parameter object: favorite recipe object
    func getDataFromCoreData(with object: NSManagedObject) {
        self.name = object.value(forKey: "name") as! String
        self.id = object.value(forKey: "id") as! String
        self.serving = object.value(forKey: "serving") as! String
        let data = object.value(forKey: "ingredientLines") as! Data        
        self.ingredientLines = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String]
        self.ingredientList = object.value(forKey: "ingredientList") as! String
        self.totalTime = object.value(forKey: "totalTime") as! String
        self.rating = object.value(forKey: "rating") as! Double
        self.smallImage = object.value(forKey: "smallImage") as! UIImage
        self.largeImage = object.value(forKey: "largeImage") as! UIImage
    }
}
