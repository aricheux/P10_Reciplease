//
//  RecipeManager.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//
import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData

/// Class to handle the recipe manager
class RecipeManager {
    /// Singleton to share the RecipeManager to all project
    static let sharedInstance = RecipeManager()
    /// Yummly app id to send the request to yummly api
    private let yummlyAppId = "11f579f1"
    /// Yummly app key to send the request to yummly api
    private let yummlyAppKey = "776a26da022bbda59c4b88b299352015"
    /// Array who contains all search ingredients
    var ingredients: [String] = []
    /// String who contains search ingredients in list for request
    var ingredientList = String()
    /// Array of NSManagedObject who contains all favorite recipes from the core data
    var favoriteRecipe: [NSManagedObject] = []
    /// Initialize the core data context to managed the core data
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// Get all recipes from Yummly with search ingredients
    ///
    /// - Parameter completion: if success, JSON data is return in completion
    func searchRecipe(completion: @escaping (JSON, Error?) -> ()) {
        let yummyUrl = "http://api.yummly.com/v1/api/recipes?"
        let parameters = ["_app_id": yummlyAppId, "_app_key": yummlyAppKey, "q": ingredientList, "requirePictures": "true"]
        
        Alamofire.request(yummyUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                if let reponse = response.result.value {
                    completion(JSON(reponse), nil)
                }
            case .failure(let error):
                completion(JSON.null, error)
            }
        }
    }
    
    /// Get more data for a specific recipe from Yummly
    ///
    /// - Parameters:
    ///   - recipeId: id of the specific recipe
    ///   - completion: if success, JSON data is return in completion
    func getRecipeDetail(with recipeId: String, completion: @escaping (JSON, Error?) -> ()) {
        let yummyUrl = "http://api.yummly.com/v1/api/recipe/" + recipeId
        let parameters = ["_app_id": yummlyAppId, "_app_key": yummlyAppKey]
        Alamofire.request(yummyUrl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                if let reponse = response.result.value {
                    completion(JSON(reponse), nil)
                }
            case .failure(let error):
                completion(JSON.null, error)
            }
        }
    }
    
    /// Get recipe image from url
    ///
    /// - Parameters:
    ///   - url: contain the url for the image data
    ///   - completion: if success, JSON data is return in completion
    func getRecipeImage(from url: String, completion: @escaping (UIImage, Error?) -> ()) {
        if !url.isEmpty {
            Alamofire.request(url).responseImage { response in
                switch response.result {
                case .success:
                    if let image = response.result.value {
                        completion(image, nil)
                    }
                case .failure(let error):
                    completion(UIImage(), error)
                }
            }
        } else {
            completion( #imageLiteral(resourceName: "defaultImage"), nil)
        }
    }
    
    
    /// Add ingredient to the search list
    ///
    /// - Parameter ingredient: ingredient to add in the list
    func addIngredient(_ ingredient: String) {
        ingredients.append(ingredient)
        formatIngredientInList()
    }
    
    /// Clear all ingredients in the search list
    func clearIngredientList() {
        ingredients = []
        ingredientList = ""
    }
    
    /// Format ingredient list in string to send it in the request
    func formatIngredientInList() {
        ingredientList = ""
        for i in 0...ingredients.count - 1 {
            if i > 0 {
                ingredientList += "&"
            }
            ingredientList += ingredients[i]
        }
    }
    
    /// Check if the recipe is present in the core data
    func recipeIsFavorite(_ id: String) -> Bool {
        if favoriteRecipe.count > 0 {
            for favoriteRecipe in favoriteRecipe {
                if id == favoriteRecipe.value(forKey: "id") as! String {
                    return true
                }
            }
        }
        return false
    }
    
    /// Load favorite recipe from core data
    ///
    /// - Parameter completion: status to know if the request is success
    func loadFromCoreData(completion: @escaping (Bool) -> ()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreRecipe")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetch = try coreDataContext.fetch(fetchRequest)
            let managedObject = fetch as! [NSManagedObject]
            self.favoriteRecipe = managedObject
            completion(true)
        }catch {
            completion(false)
        }
    }
    
    /// Save the favorite recipe in the core data
    ///
    /// - Parameter completion: status to know if the request is success
    func saveToCoreData(_ recipe: Recipe, completion: @escaping (Bool) -> ()) {
        if let entity = NSEntityDescription.entity(forEntityName: "CoreRecipe",in: coreDataContext) {
            let coreRecipe = NSManagedObject(entity: entity, insertInto: coreDataContext)
            
            coreRecipe.setValue(recipe.name, forKey: "name")
            coreRecipe.setValue(recipe.id, forKey: "id")
            coreRecipe.setValue(recipe.serving, forKey: "serving")
            coreRecipe.setValue(recipe.imageUrl, forKey: "imageUrl")
            let data = NSKeyedArchiver.archivedData(withRootObject: recipe.ingredientLines)
            coreRecipe.setValue(data, forKey: "ingredientLines")
            coreRecipe.setValue(recipe.ingredientList, forKey: "ingredientList")
            coreRecipe.setValue(recipe.rating, forKey: "rating")
            coreRecipe.setValue(recipe.totalTime, forKey: "totalTime")
            coreRecipe.setValue(recipe.smallImage, forKey: "smallImage")
            coreRecipe.setValue(recipe.largeImage, forKey: "largeImage")
            coreRecipe.setValue(recipe.sourceRecipeUrl, forKey: "sourceRecipeUrl")
            
            do {
                try coreDataContext.save()
                self.loadFromCoreData(){ _ in }
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    /// Delete the favorite recipe from the core data
    ///
    /// - Parameter completion: status to know if the request is success
    func deleteFromCoreData(_ recipe: Recipe, completion: @escaping (Bool) -> ()) {
        for favoriteRecipe in favoriteRecipe {
            if recipe.id == favoriteRecipe.value(forKey: "id") as! String {
                coreDataContext.delete(favoriteRecipe)
            }
        }
        
        do {
            try coreDataContext.save()
            self.loadFromCoreData(){ _ in }
            completion(true)
        } catch {
            completion(false)
        }
    }
}
