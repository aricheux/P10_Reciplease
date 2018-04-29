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

class FavoriteDetailController: UITableViewController {
    
    var managedObject: NSManagedObject?
    var recipe = Recipe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        getContent()
    }
    
    func setupContent() {
        let favoriteItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(favoriteTapped))
        favoriteItem.image = #imageLiteral(resourceName: "starFull")
        navigationItem.rightBarButtonItem = favoriteItem
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RecipeImageCell", bundle: nil), forCellReuseIdentifier: "RecipeImageCell")
        tableView.register(UINib(nibName: "RecipeInfoCell", bundle: nil), forCellReuseIdentifier: "RecipeInfoCell")
        tableView.register(UINib(nibName: "RecipeWebCell", bundle: nil), forCellReuseIdentifier: "RecipeWebCell")
    }
    
    func getContent() {
        if let managedObject = managedObject {
            recipe.getDataFromCoreData(with: managedObject)
            self.tableView.reloadData()
        }
    }
    
    @objc func showWebRecipe(_ sender: UIButton){
        if let url = URL(string: recipe.sourceRecipeUrl) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func favoriteTapped() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(managedObject!)
        
        do {
            try context.save()
            print("save")
            _ = navigationController?.popToRootViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
extension FavoriteDetailController {
    
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
