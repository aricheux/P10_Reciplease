//
//  TableRecipeController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultRecipeController: UITableViewController {
    
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

extension ResultRecipeController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeMatches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResultRecipeCell, let recipeMatch = recipeMatches  else {
            return UITableViewCell()
        }
        
        let recipe = SearchRecipe(with: recipeMatch[indexPath.row])
        cell.recipeTitle.text = recipe.title
        cell.recipeIngredient.text = recipe.ingredientList
        cell.setRatingStar(rating: recipe.rating)
        cell.recipeTime.text = recipe.executionTime
        
        RecipeManager.sharedInstance.getRecipeImage(from: recipe.imageUrl){ (image, error) in
            if error == nil {
                cell.recipeImage.image = image
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetail" {
            if let destination = segue.destination as? DetailRecipeController, let recipeIndex = tableView.indexPathForSelectedRow?.row, let recipeMatch = self.recipeMatches {
                destination.recipeId = recipeMatch[recipeIndex]["id"].stringValue
            }
        }
    }
}
