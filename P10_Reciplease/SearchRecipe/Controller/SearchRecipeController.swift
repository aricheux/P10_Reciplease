//
//  FirstViewController.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchRecipeController: UIViewController {
    
    @IBOutlet weak var ingredientText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RecipeManager.sharedInstance.addIngredient("eggs")
        RecipeManager.sharedInstance.addIngredient("cheese")
    }

    @IBAction func addIngredient(_ sender: Any) {
        RecipeManager.sharedInstance.addIngredient(ingredientText.text)
        self.ingredientText.text = ""
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.ingredientText.resignFirstResponder()
    }

}

