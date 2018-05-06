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
    let spinnerView = SpinnerView()
    var numberOfSection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        getContent()
    }
    
    func setupContent() {
        spinnerView.setLoadingScreen(tableView: tableView, navigationController: navigationController)
        numberOfSection = 0
        setupFavoriteItem()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RecipeImageCell", bundle: nil), forCellReuseIdentifier: "RecipeImageCell")
        tableView.register(UINib(nibName: "RecipeInfoCell", bundle: nil), forCellReuseIdentifier: "RecipeInfoCell")
        tableView.register(UINib(nibName: "RecipeWebCell", bundle: nil), forCellReuseIdentifier: "RecipeWebCell")
        tableView.register(UINib(nibName: "RecipeHeaderCell", bundle: nil), forCellReuseIdentifier: "RecipeHeaderCell")
    }
    
    func setupFavoriteItem() {
        starView.settings.totalStars = 1
        starView.settings.starSize = 35
        starView.rating = 0.0
        starView.settings.updateOnTouch = false
        
        let favoriteItem = UIBarButtonItem(customView: starView)
        favoriteItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteTapped)))
        navigationItem.rightBarButtonItem = favoriteItem
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
                    self.numberOfSection = 5
                    self.tableView.reloadData()
                    self.spinnerView.removeLoadingScreen()
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
        return numberOfSection ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
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
            cell.recipeImage.contentMode = .scaleAspectFit
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoCell", for: indexPath) as! RecipeInfoCell
            cell.recipeName.text = recipe.name
            cell.recipeTime.text = recipe.totalTime
            cell.recipeRating.rating = recipe.rating
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeHeaderCell", for: indexPath) as! RecipeHeaderCell
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = " - " + recipe.ingredientLines[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeWebCell", for: indexPath) as! RecipeWebCell
            cell.getDirectionButton.addTarget(self, action: #selector(self.showWebRecipe(_:)), for: .touchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
