//
//  RecipeImageCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 08/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

/// Class to handle the RecipeImageCell
class RecipeImageCell: UITableViewCell {
    /// Large image description of the recipe
    @IBOutlet weak var recipeImage: UIImageView!
    
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
        self.recipeImage.image = recipe.largeImage
    }
    
}
