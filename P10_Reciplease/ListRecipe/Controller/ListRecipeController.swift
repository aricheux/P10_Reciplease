//
//  TableRecipeController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListRecipeController: UITableViewController {
    
    var recipeMatches: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        searchRecipe()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchRecipe()
    }
    
    func searchRecipe() {
        RecipeManager.sharedInstance.searchRecipe() { (jsonResult, error) in
            if error == nil {
                
                self.recipeMatches = jsonResult["matches"]
                self.tableView.reloadData()
            }
        }
    }
}

extension ListRecipeController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeMatches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeMatch = recipeMatches, let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListRecipeCell  else {
            return UITableViewCell()
        }
        
        let recipe = Recipe(with: recipeMatch[indexPath.row])
        cell.textLabel?.text = recipe.title
        
       // cell.weatherSkyCondition.text = weather.skyCondition

        return cell
    }
}
