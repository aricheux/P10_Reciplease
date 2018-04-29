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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
