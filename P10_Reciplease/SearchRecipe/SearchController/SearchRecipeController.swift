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
    @IBOutlet weak var searchList: UITableView!
    /// String who contain the text to put when the textview is empty
    let placeholder = "eggs, cheese, ham, ..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        RecipeManager.sharedInstance.addIngredient("eggs")
        RecipeManager.sharedInstance.addIngredient("cheese")
        
        searchList.tableFooterView = UIView()
        searchList.reloadData()
    }
    
    @IBAction func addIngredientToList(_ sender: Any) {
        if let ingredient = ingredientText.text, !ingredient.isEmpty, ingredient != placeholder {
            RecipeManager.sharedInstance.addIngredient(ingredient)
            self.ingredientText.text = ""
            searchList.reloadData()
        } else {
            self.errorPopUp()
        }
    }
    /// Show an error pop-up if the API request have a problem
    func errorPopUp() {
        let alertVC = UIAlertController(title: "", message: "Veuillez renseigner un ingrédient", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func clearList(_ sender: Any) {
        RecipeManager.sharedInstance.clearIngredientList()
        searchList.reloadData()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.ingredientText.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
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

/// Extension of UITextViewDelegate to handle the place holder
extension SearchRecipeController: UITextViewDelegate {
    /// replace the placeholder by an empty string
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == placeholder)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    /// Replace the empty text by a placeholder
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
