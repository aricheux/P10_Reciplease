//
//  FirstViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchRecipeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ingredientText: UITextField!
    @IBOutlet weak var recipeList: SearchListController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RecipeManager.sharedInstance.addIngredient("eggs")
        RecipeManager.sharedInstance.addIngredient("cheese")
        
        recipeList.tableFooterView = UIView()
        recipeList.reloadData()
    }

    @IBAction func addIngredient(_ sender: Any) {
        RecipeManager.sharedInstance.addIngredient(ingredientText.text)
        self.ingredientText.text = ""
        recipeList.reloadData()
    }
    
    @IBAction func clearList(_ sender: Any) {
        RecipeManager.sharedInstance.clearIngredientList()
        recipeList.reloadData()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.ingredientText.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecipeManager.sharedInstance.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = RecipeManager.sharedInstance.ingredients[indexPath.row]
        
        return cell
    }

}
