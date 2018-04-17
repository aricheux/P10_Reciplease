//
//  TableRecipeController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableRecipeController: UITableViewController {
    
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

extension TableRecipeController {
    
    /// Create the number of section in the table view
    ///
    /// - Parameters:
    ///   - tableView: current table view
    ///   - section: current section index
    /// - Returns: Number of city weather retrieved from JSON
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeMatches?.count ?? 0
    }
    
    /// Create the tableview cell with weather data from weather class
    ///
    /// - Parameters:
    ///   - tableView: current table view
    ///   - indexPath: current row index
    /// - Returns: tableview cell created
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeMatch = recipeMatches, let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecipeTableViewCell  else {
            return UITableViewCell()
        }
        
        let recipe = Recipe(with: recipeMatch[indexPath.row])
        
        cell.textLabel?.text = recipe.title
        
        return cell
    }
}
