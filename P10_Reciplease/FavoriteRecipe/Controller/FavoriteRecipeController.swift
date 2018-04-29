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
    
    var favoriteRecipe: [NSManagedObject] = []
    
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
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreRecipe")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let fetch = try context.fetch(fetchRequest)
            
            favoriteRecipe = fetch as! [NSManagedObject]
            self.tableView.reloadData()

        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
}

extension FavoriteRecipeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipe.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultRecipeCell", for: indexPath) as! ResultRecipeCell
        
        cell.recipeTitle.text = favoriteRecipe[indexPath.row].value(forKey: "name") as? String
        cell.recipeIngredient.text = favoriteRecipe[indexPath.row].value(forKey: "ingredientList") as? String
        cell.recipeTime.text = favoriteRecipe[indexPath.row].value(forKey: "totalTime") as? String
        cell.rateStars.rating = favoriteRecipe[indexPath.row].value(forKey: "rating") as! Double
        cell.recipeImage.image = favoriteRecipe[indexPath.row].value(forKey: "largeImage") as? UIImage
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

