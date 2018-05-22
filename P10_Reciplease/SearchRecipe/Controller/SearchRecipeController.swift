//
//  FirstViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON
import SearchTextField

class SearchRecipeController: UIViewController {
    
    @IBOutlet weak var newIngredient: SearchTextField!
    @IBOutlet weak var searchTable: UITableView!
    let popUp = MessagePopUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJsonList()
        setupIngredientTextStyle()
        setupBottomBorder()
        setupTableView()
    }
    
    func getJsonList(){
        if let path = Bundle.main.path(forResource: "ingredient", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let ingredients = jsonResult["ingredient"] as? [String] {
                    self.newIngredient.filterStrings(ingredients)
                }
            } catch {
                self.popUp.showMessageWith("Erreur", "Erreur lors de la récupération de la liste", self, .RetryButton, completion: { (choice) in
                    
                    if choice == .RetryPushed {
                        self.setupIngredientTextStyle()
                    }
                })
            }
        }
    }
    
    func setupIngredientTextStyle() {
        newIngredient.theme.bgColor = UIColor.white
        newIngredient.theme.fontColor = UIColor.black
        newIngredient.theme.font = UIFont.systemFont(ofSize: 15)
        newIngredient.theme.separatorColor = UIColor.gray
        newIngredient.theme.cellHeight = 30
        newIngredient.highlightAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)]
        newIngredient.theme.placeholderColor = UIColor.lightGray
    }
    
    func setupBottomBorder(){
        let bottomBorder = CALayer()
        bottomBorder.borderColor = UIColor.white.cgColor
        bottomBorder.borderWidth = 2
        bottomBorder.frame = CGRect(x: 0, y: newIngredient.frame.height-1, width: newIngredient.frame.width-1, height: 1)
        newIngredient.clipsToBounds = true
        newIngredient.layer.addSublayer(bottomBorder)
    }
    
    func setupTableView() {
        searchTable.accessibilityIdentifier = "ingredientTable"
        searchTable.tableFooterView = UIView()
        searchTable.register(UINib(nibName: "SearchClearCell", bundle: nil), forCellReuseIdentifier: "SearchClearCell")
        searchTable.register(UINib(nibName: "SearchRecipeCell", bundle: nil), forCellReuseIdentifier: "SearchRecipeCell")
        searchTable.reloadData()
    }
    
    @objc func clearList(_ sender: Any) {
        RecipeManager.sharedInstance.clearIngredientList()
        searchTable.reloadData()
    }
    
    @IBAction func addIngredientToList(_ sender: Any) {
        if let ingredient = newIngredient.text, !ingredient.isEmpty {
            RecipeManager.sharedInstance.addIngredient(ingredient)
            newIngredient.text = ""
            searchTable.reloadData()
        } else {
            self.popUp.showMessageWith("Erreur", "Veuillez renseigner un ingrédient", self, .OkButton, completion: { _ in })
        }
    }
    
    @IBAction func goToResultPage( _ sender: Any){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "ResultRecipe", bundle:nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ResultRecipe") as! ResultRecipeController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Dismiss keyboard if the user tap outside of it
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        newIngredient.resignFirstResponder()
    }
}

extension SearchRecipeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return RecipeManager.sharedInstance.ingredients.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchClearCell", for: indexPath) as! SearchClearCell
            cell.clearIngredient.addTarget(self, action: #selector(self.clearList(_:)), for: .touchUpInside)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = " - " + RecipeManager.sharedInstance.ingredients[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
