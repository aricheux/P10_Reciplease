//
//  ResultRecipeCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 05/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import Cosmos

class ResultRecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredient: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var rateStars: CosmosView!
    @IBOutlet weak var recipeTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(recipe: Recipe) {
        self.recipeTitle.text = recipe.name
        self.recipeIngredient.text = recipe.ingredientList
        self.recipeTime.text = recipe.totalTime
        self.rateStars.rating = recipe.rating
        self.recipeImage.image = recipe.smallImage
    }
    
}
