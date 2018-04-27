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
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    
    func setupContent() {
        setLoadingScreen()
        self.tableView.tableFooterView = UIView()
        searchRecipe()
    }
    
    func searchRecipe() {
        RecipeManager.sharedInstance.searchRecipe() { (jsonResult, error) in
            if error == nil {
                self.recipeMatches = jsonResult["matches"]
                self.tableView.reloadData()
                self.removeLoadingScreen()
            }
        }
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        tableView.addSubview(loadingView)
    }
    
    private func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
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
        
        let recipe = Recipe(with: recipeMatch[indexPath.row], type: .Search)
        cell.recipeTitle.text = recipe.name
        cell.recipeIngredient.text = recipe.ingredientList
        cell.recipeTime.text = recipe.totalTime
        cell.rateStars.rating = recipe.rating
        
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
