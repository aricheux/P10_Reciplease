//
//  SecondViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

/// Class to handle the FavoriteRecipeController
class FavoriteRecipeController: UITableViewController {
    /// Array of favorite recipe
    var favoriteRecipe: [Recipe] = []
    /// Define a pop-up to alert the user
    let popUp = MessagePopUp()
    
    /// Do action when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
    }
    
    /// Get content when the view appear again
    override func viewWillAppear(_ animated: Bool) {
        getContent()
    }
    
    /// Register all xib of the table view
    func setupContent() {
        tableView.tableFooterView = UIView()
        tableView.accessibilityIdentifier = "favoriteTable"
        tableView.register(UINib(nibName: "ResultRecipeCell", bundle: nil), forCellReuseIdentifier: "ResultRecipeCell")
        tableView.register(UINib(nibName: "NoFavoriteCell", bundle: nil), forCellReuseIdentifier: "NoFavoriteCell")
    }
    
    /// Load data from the core data and setup the table view
    func getContent() {
        RecipeManager.sharedInstance.loadFromCoreData() { (success) in
            if success {
                let coreDataRecipe = RecipeManager.sharedInstance.favoriteRecipe
                
                self.favoriteRecipe.removeAll()
                if coreDataRecipe.count > 0 {
                    for i in 0...coreDataRecipe.count-1 {
                        self.favoriteRecipe.append(Recipe())
                        self.favoriteRecipe[i].getDataFromCoreData(with: coreDataRecipe[i])
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
}

/// Handle methode of UITableViewDelegate and UITableViewDataSource
extension FavoriteRecipeController {
    
    /// Define the number of row by section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.allowsSelection = (favoriteRecipe.count > 0)
        if (favoriteRecipe.count > 0) {
            return favoriteRecipe.count
        }
        return 1
    }
    
    /// Create and configure the cell with xib according the section index
    /// Add a defaut cell to help the user to add a new favorite
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if favoriteRecipe.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
            cell.setupWith(recipe: favoriteRecipe[indexPath.row])
 
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavoriteCell", for: indexPath) as! NoFavoriteCell
            
            return cell
        }
    }
    
    /// Send recipe data and push the new view controller when the cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "DetailRecipe", bundle:nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailRecipe") as! DetailRecipeController
        vc.recipe = favoriteRecipe[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Swipe left to delete the favorite recipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {        
        if editingStyle == .delete {
            RecipeManager.sharedInstance.deleteFromCoreData(favoriteRecipe[indexPath.row]){ (success) in
                if success {
                    self.getContent()
                } else {
                    self.popUp.showMessageWith("Erreur", "Erreur lors de la suppression de la recette", self, .OkButton, completion: { _ in })
                }
            }
        }
    }
}

