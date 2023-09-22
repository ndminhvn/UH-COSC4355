//
//  GameViewController.swift
//  Exam1_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/21/23.
//

import UIKit

func game_checker(imageViews: [UIImageView]) -> [UIImageView]? {
    // Define the winning combinations (indexes of imageViews)
    let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6] // Diagonals
    ]
    
    for combination in winningCombinations {
        let firstImageView = imageViews[combination[0]]
        let secondImageView = imageViews[combination[1]]
        let thirdImageView = imageViews[combination[2]]
        
        // Check if the accessibility identifiers (image names) match and are not empty
        if let firstImageName = firstImageView.image?.accessibilityIdentifier,
           let secondImageName = secondImageView.image?.accessibilityIdentifier,
           let thirdImageName = thirdImageView.image?.accessibilityIdentifier,
           !firstImageName.isEmpty,
           firstImageName == secondImageName && secondImageName == thirdImageName {
            // Found a winning combination
            return [firstImageView, secondImageView, thirdImageView]
        }
    }
    
    return nil // No winning combination found
}


class GameViewController: UIViewController {
    
    let icons = ["circle_0", "cross_0"]
    
    @IBOutlet weak var Credit: UILabel!
    @IBOutlet weak var Bet: UILabel!
    
    @IBOutlet weak var s11: UIImageView!
    @IBOutlet weak var s12: UIImageView!
    @IBOutlet weak var s13: UIImageView!
    
    @IBOutlet weak var s21: UIImageView!
    @IBOutlet weak var s22: UIImageView!
    @IBOutlet weak var s23: UIImageView!
    
    
    @IBOutlet weak var s31: UIImageView!
    @IBOutlet weak var s32: UIImageView!
    @IBOutlet weak var s33: UIImageView!
    
    
    @IBAction func PlayButton(_ sender: UIButton) {
        let s_list: [UIImageView] = [s11, s12, s13, s21, s22, s23, s31, s32, s33]
        
        for s in 0 ..< s_list.count {
            let random = Int(arc4random_uniform(UInt32(icons.count)))
            s_list[s].image = UIImage(named: icons[random])
        }
        
        if let combination = game_checker(imageViews: s_list) {
            if let creditValue = Int(Credit.text ?? ""), let betValue = Int(Bet.text ?? "") {
                let newCreditValue = creditValue - betValue
                Credit.text = "\(newCreditValue)"
            }


            // Update the images in the winning combination
            for imageView in combination {
                if let imageName = imageView.image?.accessibilityIdentifier {
                    switch imageName {
                        case "cross_0":
                            imageView.image = UIImage(named: "cross_1")
                        case "circle_0":
                            imageView.image = UIImage(named: "circle_1")
                        default:
                            break
                    }
                }
            }
        }
    }
    
    @IBAction func BetButton(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
