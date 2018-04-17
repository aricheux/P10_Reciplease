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
    let yummlyAppId = "11f579f1"
    let yummlyAppKey = "776a26da022bbda59c4b88b299352015"
    
    func searchRecipe(with param: String, completion: @escaping (JSON, Error?) -> ()) {
        let yummyUrl = "http://api.yummly.com/v1/api/recipes?"
        let parameters = ["_app_id": yummlyAppId, "_app_key": yummlyAppKey, "q": param, "requirePictures": "true"]
        
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
}
