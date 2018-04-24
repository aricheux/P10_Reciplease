//
//  RecipeTableViewCell.swift
//  
//
//  Created by RICHEUX Antoine on 17/04/2018.
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
        
        // Configure the view for the selected state
    }
    
}
