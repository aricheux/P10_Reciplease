//
//  DetailRecipeControllerViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 20/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailRecipeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var detailRecipe: Recipe?
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeCategory: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredientList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecipeDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupRecipeDetail()
    }
    
    func setupRecipeDetail() {
        if let recipe = detailRecipe {
            self.recipeImage.image = recipe.image
            self.recipeTitle.text = recipe.title
            self.recipeTime.text = recipe.executionTime
            self.recipeCategory.text = recipe.category
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRecipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = detailRecipe?.ingredients[indexPath.row].stringValue

        return cell
    }
    
}
