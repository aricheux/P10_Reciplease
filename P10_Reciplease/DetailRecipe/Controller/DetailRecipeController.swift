//
//  DetailRecipeControllerViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 20/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData
import Cosmos

class DetailRecipeController: UITableViewController {
    
    var recipe = Recipe()
    let starView = CosmosView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        getContent()
    }
    
    func setupContent() {
        starView.settings.totalStars = 1
        starView.settings.starSize = 35
        self.starView.rating = 0.0
        starView.settings.updateOnTouch = false

        let favoriteItem = UIBarButtonItem(customView: starView)
        favoriteItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteTapped)))
        navigationItem.rightBarButtonItem = favoriteItem
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RecipeImageCell", bundle: nil), forCellReuseIdentifier: "RecipeImageCell")
        tableView.register(UINib(nibName: "RecipeInfoCell", bundle: nil), forCellReuseIdentifier: "RecipeInfoCell")
        tableView.register(UINib(nibName: "RecipeWebCell", bundle: nil), forCellReuseIdentifier: "RecipeWebCell")
    }
    
    func getContent() {
        RecipeManager.sharedInstance.getRecipeDetail(with: recipe.id) { (jsonResult, error) in
            if error == nil {
                self.recipe.getDetailData(with: jsonResult) { (result) in
                    if RecipeManager.sharedInstance.recipeIsFavorite(self.recipe.id){
                        self.starView.rating = 1.0
                    } else {
                        self.starView.rating = 0.0
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func showWebRecipe(_ sender: UIButton){
        if let url = URL(string: recipe.sourceRecipeUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func favoriteTapped() {
        if self.starView.rating == 0 {
            RecipeManager.sharedInstance.saveToCoreData(self.recipe) { (success) in
                if success {
                    self.starView.rating = 1
                }
            }
        } else {
            RecipeManager.sharedInstance.deleteFromCoreData(self.recipe){ (success) in
                if success {
                    self.starView.rating = 0
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
extension DetailRecipeController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 2) {
            return "Ingredients"
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return recipe.ingredientLines.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeImageCell", for: indexPath) as! RecipeImageCell
            cell.recipeImage.image = recipe.largeImage
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoCell", for: indexPath) as! RecipeInfoCell
            cell.recipeName.text = recipe.name
            cell.recipeTime.text = recipe.totalTime
            cell.recipeRating.rating = recipe.rating
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = recipe.ingredientLines[indexPath.row]
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view  = tableView.dequeueReusableCell(withIdentifier: "RecipeWebCell") as! RecipeWebCell
        view.getDirectionButton.addTarget(self, action: #selector(self.showWebRecipe(_:)), for: .touchUpInside)
        
        if section == 2 {
            return view
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 80
        } else {
            return 0
        }
    }
    
}
