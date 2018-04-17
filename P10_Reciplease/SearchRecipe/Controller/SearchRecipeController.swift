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
    
    var jsonData: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableRecipeController
        destinationVC.jsonData = self.jsonData
    }
//
//    @IBAction func searchRecipe(_ sender: UIButton) {
//        let ingredient = "eggs&cheese&ham"
//        
//        RecipeManager.sharedInstance.searchRecipe(with: ingredient) { (jsonDict, error) in
//            if error == nil {
//                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResult") as! SearchResultController
//                secondViewController.jsonData = jsonDict
//                self.navigationController?.pushViewController(secondViewController, animated: true)
//            } else {
//                print(error!)
//            }
//        }
//    }
}

