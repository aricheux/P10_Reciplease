//
//  TableRecipeController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResultRecipeController: UITableViewController {
    
    var recipeMatches: JSON?
    var recipe: [Recipe] = []
    let spinnerView = SpinnerView()
    let popUp = MessagePopUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
        getContent()
    }
    
    func setupContent() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Result", style: .plain, target: nil, action: nil)
        spinnerView.setLoadingScreen(tableView: tableView, navigationController: navigationController)
        tableView.accessibilityIdentifier = "resultTable"
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ResultRecipeCell", bundle: nil), forCellReuseIdentifier: "ResultRecipeCell")
    }
    
    func getContent() {
        RecipeManager.sharedInstance.searchRecipe() { (jsonResult, error) in
            if error == nil {
                self.recipeMatches = jsonResult["matches"]
                self.recipe.removeAll()
                self.tableView.reloadData()
                self.spinnerView.removeLoadingScreen()
            } else {
                self.popUp.showMessageWith("Erreur", "Erreur lors du chargement des résultats", self, .RetryButton, completion: { (choice) in
                    if choice == .RetryPushed {
                        self.getContent()
                    } else if choice == .CancelPushed {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
}

extension ResultRecipeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeMatches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeMatches = recipeMatches else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
        recipe.append(Recipe())
        recipe[indexPath.row].getSearchData(with: recipeMatches[indexPath.row]) { (result) in
            if (result == true) {
                cell.setupWith(recipe: self.recipe[indexPath.row])
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "DetailRecipe", bundle:nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "DetailRecipe") as! DetailRecipeController
        vc.recipe = self.recipe[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
