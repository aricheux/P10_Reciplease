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
    
    var recipeObject: [Recipe] = []
    
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
                let recipeMatches = jsonResult["matches"]
                self.recipeObject = []
                for recipeMatch in recipeMatches {
                    self.recipeObject.append(Recipe(with: recipeMatch.1))
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension ResultRecipeController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeObject.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ResultRecipeCell  else {
            return UITableViewCell()
        }
        
        let recipe = self.recipeObject[indexPath.row]
        cell.recipeTitle.text = recipe.title
        cell.recipeIngredient.text = recipe.ingredientList
        cell.setRatingStar(rating: recipe.rating)
        cell.recipeTime.text = recipe.executionTime
        
        RecipeManager.sharedInstance.getRecipeImage(from: recipe.imageUrl){ (image, error) in
            if error == nil {
                cell.recipeImage.image = image
                self.recipeObject[indexPath.row].image = image
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetail" {
            if let destination = segue.destination as? DetailRecipeController, let recipeIndex = tableView.indexPathForSelectedRow?.row {
                destination.detailRecipe = self.recipeObject[recipeIndex]
            }
        }
    }
}
