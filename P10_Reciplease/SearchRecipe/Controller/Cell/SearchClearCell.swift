//
//  SearchHeaderCell.swift
//  P10_Reciplease
//
//  Created by RICHEUX Antoine on 04/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit

/// Class to handle the SearchClearCell
class SearchClearCell: UITableViewCell {
    /// Clear button to remove all ingredient
    @IBOutlet weak var clearIngredient: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
