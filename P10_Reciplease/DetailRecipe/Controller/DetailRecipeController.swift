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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        getContent()
    }
    
    func setupContent() {

        let starView = CosmosView()
        starView.settings.totalStars = 1
        starView.settings.starSize = 35
        starView.settings.updateOnTouch = true
        starView.rating = 0

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
        saveRecipe()
    }
    
    func saveRecipe() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "CoreRecipe",in: context) {
            let coreRecipe = NSManagedObject(entity: entity, insertInto: context)
            
            coreRecipe.setValue(recipe.name, forKey: "name")
            coreRecipe.setValue(recipe.id, forKey: "id")
            coreRecipe.setValue(recipe.imageUrl, forKey: "imageUrl")
            let data = NSKeyedArchiver.archivedData(withRootObject: recipe.ingredientLines)
            coreRecipe.setValue(data, forKey: "ingredientLines")
            coreRecipe.setValue(recipe.ingredientList, forKey: "ingredientList")
            coreRecipe.setValue(recipe.rating, forKey: "rating")
            coreRecipe.setValue(recipe.totalTime, forKey: "totalTime")
            coreRecipe.setValue(recipe.smallImage, forKey: "smallImage")
            coreRecipe.setValue(recipe.largeImage, forKey: "largeImage")
            coreRecipe.setValue(recipe.sourceRecipeUrl, forKey: "sourceRecipeUrl")
            
            do {
                try context.save()
                print("Recette save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
extension DetailRecipeController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 2) {
            return "Ingredients"
        } else if (section == 3) {
            return "Detailed instructions"
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
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeWebCell", for: indexPath) as! RecipeWebCell
            cell.getDirectionButton.addTarget(self, action: #selector(self.showWebRecipe(_:)), for: .touchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
}
