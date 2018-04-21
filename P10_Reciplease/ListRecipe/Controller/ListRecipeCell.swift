//
//  RecipeTableViewCell.swift
//  
//
//  Created by RICHEUX Antoine on 17/04/2018.
//

import UIKit

class ListRecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredient: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet var ratingStar: [UIImageView]!
    
    @IBOutlet weak var recipeTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setRatingStar(rating: Double) {
        for i in 0...ratingStar.count-1 {
            ratingStar[i].image = #imageLiteral(resourceName: "starEmpty")
            if rating >= Double(i + 1) {
                ratingStar[i].image = #imageLiteral(resourceName: "starFull")
            } else if (Double(i + 1) - rating) < 0.5 {
                ratingStar[i].image = #imageLiteral(resourceName: "starHalf")
            }
        }
    }
    
}
