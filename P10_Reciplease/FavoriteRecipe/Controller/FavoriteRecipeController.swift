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

class FavoriteRecipeController: UITableViewController {
    
    var favoriteRecipe: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getContent()
    }
    
    func setupContent() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ResultRecipeCell", bundle: nil), forCellReuseIdentifier: "ResultRecipeCell")
    }
    
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

extension FavoriteRecipeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteRecipe.count > 0 {
            return favoriteRecipe.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if favoriteRecipe.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
            
            cell.recipeTitle.text = favoriteRecipe[indexPath.row].name
            cell.recipeIngredient.text = favoriteRecipe[indexPath.row].ingredientList
            cell.recipeTime.text = favoriteRecipe[indexPath.row].totalTime
            cell.rateStars.rating = favoriteRecipe[indexPath.row].rating
            cell.recipeImage.image = favoriteRecipe[indexPath.row].smallImage
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Aucun favori enregisté"
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "DetailRecipe", bundle:nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailRecipe") as! DetailRecipeController
        vc.recipe = favoriteRecipe[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

