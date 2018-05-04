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

class RecipeManager {
    /// Share the RecipeManager to all project, no need to create object in code
    static let sharedInstance = RecipeManager()
    /// yummly app id and key
    private let yummlyAppId = "11f579f1"
    private let yummlyAppKey = "776a26da022bbda59c4b88b299352015"
    ///
    var ingredients: [String] = []
    var ingredientList = String()
    var favoriteRecipe: [NSManagedObject] = []
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    func getRecipeImage(from url: String, completion: @escaping (UIImage, Error?) -> ()) {
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
    }
    
    func addIngredient(_ ingredient: String) {
        ingredients.append(ingredient)
        formatIngredientInList()
    }
    
    func clearIngredientList() {
        ingredients = []
        ingredientList = ""
    }
    
    func formatIngredientInList() {
        ingredientList = ""
        for i in 0...ingredients.count - 1 {
            if i > 0 {
                ingredientList += "&"
            }
            ingredientList += ingredients[i]
        }
        print(ingredientList)
    }
    
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
    
    func saveToCoreData(_ recipe: Recipe, completion: @escaping (Bool) -> ()) {
        if let entity = NSEntityDescription.entity(forEntityName: "CoreRecipe",in: coreDataContext) {
            let coreRecipe = NSManagedObject(entity: entity, insertInto: coreDataContext)
            
            coreRecipe.setValue(recipe.name, forKey: "name")
            coreRecipe.setValue(recipe.id, forKey: "id")
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
