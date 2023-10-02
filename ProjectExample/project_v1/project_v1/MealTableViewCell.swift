//
//  MealTableViewCell.swift
//  project_v1
//
//  Created by Huda on 11/29/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

protocol MealTableViewCellDelegate: AnyObject{
    func didTabButtonOfIng(with id: Int, excludedState: String, includedState: String)
}

class MealTableViewCell: UITableViewCell {
    
    weak var delegate:MealTableViewCellDelegate?
    
    var thisIngredient:ingredient = ingredient(id: 0,name: "dummy")
    var excludedState = "inactive"
    var includedState = "inactive"
    static let identifier = "MealTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "MealTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var ingLabel: UILabel!
    @IBOutlet var includeButton: UIButton!
    @IBOutlet var excludeButton: UIButton!
    
    @IBAction func didTapIncludeButton(){

        if self.includedState == "active"
        {
            self.includedState = "inactive"
            includeButton.setImage(UIImage(named:"inactive_include"), for: .normal)
            
        }else{
            includeButton.setImage(UIImage(named:"active_include"), for: .normal)
            self.includedState = "active"
            if self.excludedState == "active"{
                excludeButton.setImage(UIImage(named:"inactive_exclude"), for: .normal)
                self.excludedState = "inactive"
            }
        }
        delegate?.didTabButtonOfIng(with: self.thisIngredient.getId(), excludedState: self.excludedState, includedState: self.includedState)

        
    }
    @IBAction func didTapExcludeButton(with img:UIImage){

        if self.excludedState == "active"
        {
            self.excludedState = "inactive"
            excludeButton.setImage(UIImage(named:"inactive_exclude"), for: .normal)
            
        }else{
            excludeButton.setImage(UIImage(named:"active_exclude"), for: .normal)
            self.excludedState = "active"
            if self.includedState == "active"{
                includeButton.setImage(UIImage(named:"inactive_include"), for: .normal)
                self.includedState = "inactive"
            }
        }
        delegate?.didTabButtonOfIng(with: self.thisIngredient.getId(), excludedState: self.excludedState, includedState: self.includedState)


    }
  
    func configure(ing: ingredient, included: Bool, excluded: Bool) {
        self.thisIngredient = ing
        ingLabel.text! = ing.getName()
        if included{
            includeButton.setImage(UIImage(named:"active_include"), for: .normal)
        }else{
            includeButton.setImage(UIImage(named:"inactive_include"), for: .normal)
        }
        if excluded{
            excludeButton.setImage(UIImage(named:"active_exclude"), for: .normal)
        }else{
            excludeButton.setImage(UIImage(named:"inactive_exclude"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
