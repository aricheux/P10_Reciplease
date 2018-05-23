//
//  RecipeInfoCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 24/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import Cosmos

/// Class to handle the RecipeInfoCell
class RecipeInfoCell: UITableViewCell {
    /// name of the recipe
    @IBOutlet weak var recipeName: UILabel!
    /// number of stars according to the rating of the recipe
    @IBOutlet weak var recipeRating: CosmosView!
    /// time to do the recipe
    @IBOutlet weak var recipeTime: UILabel!
    /// number of serving of the recipe
    @IBOutlet weak var recipeServing: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Setup the cell with the recipe object
    func setupWith(recipe: Recipe) {
        self.recipeName.text = recipe.name
        self.recipeTime.text = recipe.totalTime
        self.recipeRating.rating = recipe.rating
        self.recipeServing.text = recipe.serving
    }
    
}
