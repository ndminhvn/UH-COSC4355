//
//  ScoreViewController.swift
//  Exercise4_Nguyen_Minh
//
//  Created by Minh Nguyen on 9/19/23.
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet var PlayerOneScoreFirst: UIImageView!
    @IBOutlet var PlayerOneScoreSecond: UIImageView!
    @IBOutlet var PlayerOneScoreThird: UIImageView!

    @IBOutlet var PlayerTwoScoreFirst: UIImageView!
    @IBOutlet var PlayerTwoScoreSecond: UIImageView!
    @IBOutlet var PlayerTwoScoreThird: UIImageView!

    var p1Score = 0
    var p2Score = 0

    var p1Scores: [UIImageView] = []
    var p2Scores: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        p1Scores = [PlayerOneScoreFirst, PlayerOneScoreSecond, PlayerOneScoreThird]

        p2Scores = [PlayerTwoScoreFirst, PlayerTwoScoreSecond, PlayerTwoScoreThird]

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if p1Score <= 3 {
            for score in 0 ..< p1Score {
                p1Scores[score].alpha = 1.0
            }
        }
        if p2Score <= 3 {
            for score in 0 ..< p2Score {
                p2Scores[score].alpha = 1.0
            }
        }
        
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
