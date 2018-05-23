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

/// Class to handle the DetailRecipeController
class DetailRecipeController: UITableViewController {
    /// Current recipe of the detail view
    var recipe = Recipe()
    /// star image for the nav bar item
    let starView = CosmosView()
    /// Spinner view when the table view loading
    let spinnerView = SpinnerView()
    /// Define the number section only when data is loaded
    var numberOfSection: Int?
    /// Define a pop-up to alert the user
    let popUp = MessagePopUp()
    
    /// Do action when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        setupFavoriteItem()
        getContent()
    }
    
    /// Get content when the view appear again
    override func viewWillAppear(_ animated: Bool) {
        getContent()
    }
    
    /// Setup spinner view and register of the table view xib
    func setupContent() {
        spinnerView.setLoadingScreen(tableView: tableView, navigationController: navigationController)
        numberOfSection = 0
        
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "detailTable"
        tableView.register(UINib(nibName: "RecipeImageCell", bundle: nil), forCellReuseIdentifier: "RecipeImageCell")
        tableView.register(UINib(nibName: "RecipeInfoCell", bundle: nil), forCellReuseIdentifier: "RecipeInfoCell")
        tableView.register(UINib(nibName: "RecipeWebCell", bundle: nil), forCellReuseIdentifier: "RecipeWebCell")
        tableView.register(UINib(nibName: "RecipeHeaderCell", bundle: nil), forCellReuseIdentifier: "RecipeHeaderCell")
    }
    
    /// Setup the star view and add it to the rightBarButtonItem
    func setupFavoriteItem() {
        starView.settings.totalStars = 1
        starView.settings.starSize = 25
        starView.rating = 0.0
        starView.settings.updateOnTouch = false
        
        let favoriteItem = UIBarButtonItem(customView: starView)
        favoriteItem.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(favoriteTapped)))
        navigationItem.rightBarButtonItem = favoriteItem
    }
    
    /// Send the request to yummly and get the detail data
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
            } else {
                self.popUp.showMessageWith("Erreur", "Erreur lors du chargement de la recette", self, .RetryButton, completion: { (choice) in
                    if choice == .RetryPushed {
                        self.getContent()
                    } else if choice == .CancelPushed {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    /// Show the web page of the original recipe
    @objc func showWebRecipe(_ sender: UIButton){
        if let url = URL(string: recipe.sourceRecipeUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    /// Add the recipe in favorite or delete it
    @objc func favoriteTapped() {
        if self.starView.rating == 0 {
            RecipeManager.sharedInstance.saveToCoreData(self.recipe) { (success) in
                if success {
                    self.starView.rating = 1
                } else {
                    self.popUp.showMessageWith("Erreur", "Erreur lors de la sauvegarde de la recette", self, .OkButton, completion: { _ in })
                }
            }
        } else {
            RecipeManager.sharedInstance.deleteFromCoreData(self.recipe){ (success) in
                if success {
                    self.starView.rating = 0
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.popUp.showMessageWith("Erreur", "Erreur lors de la suppression de la recette", self, .OkButton, completion: { _ in })
                }
            }
        }
    }
}

/// Handle methode of UITableViewDelegate and UITableViewDataSource
extension DetailRecipeController {
    
    /// Define the number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection ?? 0
    }
    
    /// Define the number of row by section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return recipe.ingredientLines.count
        } else {
            return 1
        }
    }
    
    /// Define the height of the cell according to the section
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.frame.width / 1.5
        case 1:
            return 80 // Recipe title
        case 2:
            return 30 // Header
        case 3:
            return 25 // Ingredient list
        case 4:
            return 120 // Button
        default:
            return CGFloat()
        }
    }
    
    /// Create and configure the cell with xib according the section index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeImageCell", for: indexPath) as! RecipeImageCell
            cell.setupWith(recipe: recipe)

            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoCell", for: indexPath) as! RecipeInfoCell
            cell.setupWith(recipe: recipe)

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
