//
//  RecipeWebCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 24/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

/// Class to handle the RecipeWebCell
class RecipeWebCell: UITableViewCell {
    /// button to go to the web page of the recipe
    @IBOutlet weak var getDirectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
