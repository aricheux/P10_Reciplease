//
//  RecipeInfoCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 24/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import Cosmos

class RecipeInfoCell: UITableViewCell {

    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeRating: CosmosView!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var recipeServing: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(recipe: Recipe) {
        self.recipeName.text = recipe.name
        self.recipeTime.text = recipe.totalTime
        self.recipeRating.rating = recipe.rating
        self.recipeServing.text = recipe.serving
    }
    
}
