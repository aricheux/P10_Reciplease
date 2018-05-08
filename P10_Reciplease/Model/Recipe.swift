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

enum RecipeType {
    case Search
    case Detail
}

///
class Recipe: NSObject, NSCoding {
    var name: String
    var id: String
    var imageUrl: String
    var ingredientLines: [String]
    var ingredientList: String
    var rating: Double
    var totalTime: String
    var smallImage: UIImage
    var largeImage: UIImage
    var sourceRecipeUrl: String
    var serving: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.ingredientLines, forKey: "ingredientLines")
        aCoder.encode(self.ingredientList, forKey: "ingredientList")
        aCoder.encode(self.rating, forKey: "rating")
        aCoder.encode(self.totalTime, forKey: "totalTime")
        aCoder.encode(self.largeImage, forKey: "smallImage")
        aCoder.encode(self.largeImage, forKey: "largeImage")
        aCoder.encode(self.sourceRecipeUrl, forKey: "sourceRecipeUrl")
        aCoder.encode(self.serving, forKey: "serving")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String, let id = aDecoder.decodeObject(forKey: "id") as? String, let imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String, let ingredientLines = aDecoder.decodeObject(forKey: "ingredientLines") as? [String], let ingredientList = aDecoder.decodeObject(forKey: "ingredientList") as? String, let rating = aDecoder.decodeObject(forKey: "rating") as? Double, let totalTime = aDecoder.decodeObject(forKey: "totalTime") as? String, let smallImage = aDecoder.decodeObject(forKey: "smallImage") as? UIImage, let largeImage = aDecoder.decodeObject(forKey: "largeImage") as? UIImage, let sourceRecipeUrl = aDecoder.decodeObject(forKey: "sourceRecipeUrl") as? String, let serving = aDecoder.decodeObject(forKey: "serving") as? String else {
                return nil
        }
        
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
        self.ingredientLines = ingredientLines
        self.ingredientList = ingredientList
        self.rating = rating
        self.totalTime = totalTime
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.sourceRecipeUrl = sourceRecipeUrl
        self.serving = serving
    }
    
    override init() {
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
        let minute = (secondTime % 3600) / 60
        self.totalTime = "\(minute) min"
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
        } else {
            self.largeImage = #imageLiteral(resourceName: "starFull")
        }
        
    }
    
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
