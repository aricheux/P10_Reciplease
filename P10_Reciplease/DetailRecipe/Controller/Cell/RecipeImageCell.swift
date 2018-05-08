//
//  RecipeImageCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 08/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

class RecipeImageCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
