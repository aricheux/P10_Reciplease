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
    
    let placeholder = "eggs, cheese, ham, ..."
    
    @IBOutlet weak var newIngredient: UITextField!
    @IBOutlet weak var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
    }
    
    func setupContent() {
        RecipeManager.sharedInstance.addIngredient("eggs")
        RecipeManager.sharedInstance.addIngredient("cheese")
        
        newIngredient.delegate = self
        newIngredient.text = placeholder
        newIngredient.textColor = .white
        
        setupBottomBorder()
        searchTable.tableFooterView = UIView()
        searchTable.register(UINib(nibName: "SearchClearCell", bundle: nil), forCellReuseIdentifier: "SearchClearCell")
        searchTable.register(UINib(nibName: "SearchRecipeCell", bundle: nil), forCellReuseIdentifier: "SearchRecipeCell")
        searchTable.reloadData()
    }
    
    func setupBottomBorder(){
        let bottomBorder = CALayer()
        bottomBorder.borderColor = UIColor.white.cgColor
        bottomBorder.borderWidth = 2
        bottomBorder.frame = CGRect(x: 0, y: newIngredient.frame.height-1, width: newIngredient.frame.width-1, height: 1)
        newIngredient.clipsToBounds = true
        newIngredient.layer.addSublayer(bottomBorder)
    }
    
    func errorPopUp() {
        let alertVC = UIAlertController(title: "", message: "Veuillez renseigner un ingrédient", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func clearList(_ sender: Any) {
        RecipeManager.sharedInstance.clearIngredientList()
        searchTable.reloadData()
    }
    
    @IBAction func addIngredientToList(_ sender: Any) {
        if let ingredient = newIngredient.text, !ingredient.isEmpty, ingredient != placeholder {
            RecipeManager.sharedInstance.addIngredient(ingredient)
            newIngredient.text = ""
            searchTable.reloadData()
        } else {
            self.errorPopUp()
        }
    }
    
    @IBAction func goToResultPage( _ sender: Any){
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "ResultRecipe", bundle:nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ResultRecipe") as! ResultRecipeController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Dismiss keyboard if the user tap outside of it
    @IBAction func dismissKeybord(_ sender: UITapGestureRecognizer) {
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

/// Extension of UITextViewDelegate to handle the place holder
extension SearchRecipeController: UITextFieldDelegate {
    /// replace the placeholder by an empty string
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField.text == placeholder)
        {
            textField.text = ""
            textField.textColor = .black
        }
        textField.becomeFirstResponder()
    }
    
    /// Replace the empty text by a placeholder
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField.text == "")
        {
            textField.text = placeholder
            textField.textColor = .white
        }
        textField.resignFirstResponder()
    }
}
