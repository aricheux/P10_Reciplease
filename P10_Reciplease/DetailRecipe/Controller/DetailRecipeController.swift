//
//  DetailRecipeControllerViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 20/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailRecipeController: UITableViewController {
    
    var recipeData: DetailedRecipe?
    var recipeId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
        setupRecipeDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupRecipeDetail()
    }
    
    func setupContent() {
        let favoriteItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(favoriteTapped))
        favoriteItem.image = #imageLiteral(resourceName: "starEmpty")
        navigationItem.rightBarButtonItem = favoriteItem
        
        tableView.register(UINib(nibName: "RecipeImageCell", bundle: nil), forCellReuseIdentifier: "RecipeImageCell")
        tableView.register(UINib(nibName: "RecipeInfoCell", bundle: nil), forCellReuseIdentifier: "RecipeInfoCell")
        tableView.register(UINib(nibName: "RecipeWebCell", bundle: nil), forCellReuseIdentifier: "RecipeWebCell")
    }
    
    func setupRecipeDetail() {
        RecipeManager.sharedInstance.getRecipeDetail(with: recipeId) { (jsonResult, error) in
            if error == nil {
                self.recipeData = DetailedRecipe(with: jsonResult)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showWebRecipe(_ sender: UIButton){
        if let detailedUrl = recipeData?.sourceRecipeUrl {
            if let url = URL(string: detailedUrl) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @objc func favoriteTapped() {
        
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
            return recipeData?.ingredientLines.count ?? 0
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let recipe = recipeData  else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeImageCell", for: indexPath) as! RecipeImageCell
            
            RecipeManager.sharedInstance.getRecipeImage(from: recipe.imageUrl){ (image, error) in
                if error == nil {
                    cell.recipeImage.image = image
                    print("image upload")
                }
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfoCell", for: indexPath) as! RecipeInfoCell
            cell.recipeName.text = recipe.name
            cell.recipeTime.text = recipe.totalTime
            cell.recipeRating.rating = recipe.rating
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = recipe.ingredientLines[indexPath.row].stringValue
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
