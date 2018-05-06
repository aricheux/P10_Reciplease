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
    var recipe: [Recipe] = []
    let spinnerView = SpinnerView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        getContent()
    }
    
    func setupContent() {
        spinnerView.setLoadingScreen(tableView: tableView, navigationController: navigationController)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ResultRecipeCell", bundle: nil), forCellReuseIdentifier: "ResultRecipeCell")
    }
    
    func getContent() {
        RecipeManager.sharedInstance.searchRecipe() { (jsonResult, error) in
            if error == nil {
                self.recipeMatches = jsonResult["matches"]
                self.recipe.removeAll()
                self.tableView.reloadData()
                self.spinnerView.removeLoadingScreen()
            }
        }
    }
}

extension ResultRecipeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeMatches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeMatches = recipeMatches else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
        recipe.append(Recipe())
        recipe[indexPath.row].getSearchData(with: recipeMatches[indexPath.row]) { (result) in
            cell.recipeTitle.text = self.recipe[indexPath.row].name
            cell.recipeIngredient.text = self.recipe[indexPath.row].ingredientList
            cell.recipeTime.text = self.recipe[indexPath.row].totalTime
            cell.rateStars.rating = self.recipe[indexPath.row].rating
            cell.recipeImage.image = self.recipe[indexPath.row].smallImage
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "DetailRecipe", bundle:nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailRecipe") as! DetailRecipeController
        vc.recipe = self.recipe[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
