//
//  GameViewController.swift
//  Exercise4_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/19/23.
//

import UIKit

struct Dragon {
    let name: String
    let imageName: String
    let powerLevel: Int
}

class GameViewController: UIViewController {
//     Create an array of Dragon objects
    let dragons: [Dragon] = [
        Dragon(name: "Balerion", imageName: "1_Balerion", powerLevel: 100),
        Dragon(name: "Meraxes", imageName: "1_Meraxes", powerLevel: 95),
        Dragon(name: "Sheepstealer", imageName: "1_Sheepstealer", powerLevel: 90),
        Dragon(name: "Silverwing", imageName: "2_Silverwing", powerLevel: 85),
        Dragon(name: "Meleys", imageName: "2_Meleys", powerLevel: 80),
        Dragon(name: "Quicksilver", imageName: "2_Quicksilver", powerLevel: 75),
        Dragon(name: "Stormcloud", imageName: "3_Stormcloud", powerLevel: 70),
        Dragon(name: "Drogon", imageName: "3_Drogon", powerLevel: 65),
        Dragon(name: "Viserion", imageName: "3_Viserion", powerLevel: 60),
    ]

    var p1_score = 0
    var p2_score = 0

    @IBOutlet var PlayerOneDragon: UIImageView!
    @IBOutlet var PlayerTwoDragon: UIImageView!
    @IBOutlet var Result: UILabel!

    @IBAction func RestartButton(_ sender: UIButton) {
        p1_score = 0
        p2_score = 0
        Result.text = "Prepare for the battle!"
        PlayerOneDragon.image = UIImage(named:"0_HOD_logo")
        PlayerTwoDragon.image = UIImage(named:"0_HOD_logo")
        fightBtn.isEnabled = true
    }

    @IBOutlet weak var fightBtn: UIButton!
    @IBAction func FightButton(_ sender: UIButton) {
        // Generate random index for Player 1
        let randomIndex1 = Int(arc4random_uniform(UInt32(dragons.count)))

        // Generate random index for Player 2, excluding the index of Player 1's dragon
        var randomIndex2: Int
        repeat {
            randomIndex2 = Int(arc4random_uniform(UInt32(dragons.count)))
        } while randomIndex2 == randomIndex1

        // Get the selected dragons
        let dragon1 = dragons[randomIndex1]
        let dragon2 = dragons[randomIndex2]

        // Set images for PlayerOneDragon and PlayerTwoDragon
        PlayerOneDragon.image = UIImage(named: dragon1.imageName)
        PlayerTwoDragon.image = UIImage(named: dragon2.imageName)

        // Get power levels of the selected dragons
        let powerLevel1 = dragon1.powerLevel
        let powerLevel2 = dragon2.powerLevel

        // Determine the winner based on power levels
        var resultText = ""

        if powerLevel1 > powerLevel2 {
            resultText = "\(dragon1.name) is stronger.\nPlayer 1 wins the round!"
            p1_score += 1
        } else {
            resultText = "\(dragon2.name) is stronger.\nPlayer 2 wins the round!"
            p2_score += 1
        }
        
        if p1_score == 3 {
            resultText = "Player 1 won! \(p1_score) - \(p2_score)\nRestart the game."
            fightBtn.isEnabled = false
        }
        if p2_score == 3 {
            resultText = "Player 2 won! \(p1_score) - \(p2_score)\nRestart the game."
            fightBtn.isEnabled = false
        }

        // Set the text of the Result label
        Result.text = resultText
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        let scores = tabBarController?.children[1] as! ScoreViewController
        scores.p1Score = p1_score
        scores.p2Score = p2_score
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        guard let scoreVC = segue.destination as? ScoreViewController else { return }
//        scoreVC.roundWinner = roundWinner
    ////        if let roundWinner = self.roundWinner {
    ////            scoreVC.roundWinner = roundWinner
    ////        }
//    }
}
