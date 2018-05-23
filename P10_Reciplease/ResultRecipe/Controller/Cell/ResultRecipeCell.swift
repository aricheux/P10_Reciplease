//
//  ResultRecipeCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 05/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import Cosmos

/// Class to handle the ResultRecipeCell
class ResultRecipeCell: UITableViewCell {
    /// title of the recipe
    @IBOutlet weak var recipeTitle: UILabel!
    /// ingredient list of the recipe
    @IBOutlet weak var recipeIngredient: UILabel!
    /// Image description of the recipe
    @IBOutlet weak var recipeImage: UIImageView!
    /// Number of stars according to the rating of the recipe
    @IBOutlet weak var rateStars: CosmosView!
    /// time needed to do the recipe
    @IBOutlet weak var recipeTime: UILabel!

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
        self.recipeTitle.text = recipe.name
        self.recipeIngredient.text = recipe.ingredientList
        self.recipeTime.text = recipe.totalTime
        self.rateStars.rating = recipe.rating
        self.recipeImage.image = recipe.smallImage
    }
    
}
