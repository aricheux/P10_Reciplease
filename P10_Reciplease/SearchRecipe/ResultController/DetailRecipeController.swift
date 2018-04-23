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
    
    var detailRecipe: DetailedRecipe?
    var recipeId = String()
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
        RecipeManager.sharedInstance.getRecipeDetail(with: recipeId) { (jsonResult, error) in
            if error == nil {
                self.detailRecipe = DetailedRecipe(with: jsonResult)
                if let imageUrl = self.detailRecipe?.imageUrl {
                    RecipeManager.sharedInstance.getRecipeImage(from: imageUrl){ (image, error) in
                        if error == nil {
                            self.recipeImage.image = image
                        }
                    }
                }
                self.recipeTime.text = self.detailRecipe?.totalTime
                self.recipeTitle.text = self.detailRecipe?.name
                self.ingredientList.reloadData()
            }
        }
    }
    
    
    @IBAction func showDetailedInstruction(_ sender: Any) {
        if let detailedUrl = detailRecipe?.sourceRecipeUrl {
            if let url = URL(string: detailedUrl) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailRecipe?.ingredientLines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = detailRecipe?.ingredientLines[indexPath.row].stringValue

        return cell
    }
    
}
