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

class RecipeManager {
    /// Share the RecipeManager to all project, no need to create object in code
    static let sharedInstance = RecipeManager()
    /// yummly app id and key
    private let yummlyAppId = "11f579f1"
    private let yummlyAppKey = "776a26da022bbda59c4b88b299352015"
    ///
    var ingredients: [String] = []
    var ingredientList = String()
    
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
    
    func getRecipeImage(from url: String, completion: @escaping (UIImage, Error?) -> ()) {
        Alamofire.request(url).responseImage { response in
            switch response.result {
            case .success:
                if let image = response.result.value {
                    completion(image, nil)
                }
            case .failure(let error):
                completion(UIImage(), error)
                print(error)
            }
        }
    }
    
    func addIngredient(_ ingredient: String?){
        if let strIngredient = ingredient {
            ingredients.append(strIngredient)
            formatIngredientInList()
        }
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
    }
}
