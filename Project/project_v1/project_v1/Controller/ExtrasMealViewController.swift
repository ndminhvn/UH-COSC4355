//
//  ExtrasMealViewController.swift
//  project_v1
//
//  Created by Huda on 10/28/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

protocol setRecPro {
    func sendRecipe(selectedRecipe: recipe?, selectedImg: UIImage, selectedCourse: String)
}

class ExtrasMealViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    
@IBOutlet weak var RecTabView: UITableView!

    //data variables
    var db:DBHelper = DBHelper()
    var selectedCourse: String = ""
    var selectedRecipes: [recipe] = []
    var recImg:UIImage?
    //View variables and functions
    let cellReuseIdentifier = "cell"

//delegate
var delegateVar: setRecPro?

  
   
    //loading and reloading
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    
        //configuring tableView:
        RecTabView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        RecTabView.delegate = self
        RecTabView.dataSource = self
 
        
    }
   
        
    //setting tableviwe behavior
        
        //number of rows based on search
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
               return selectedRecipes.count
       }
       // configuring cell's data and appearance
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
            cell.textLabel?.text = selectedRecipes[indexPath.row].getName()
          print(" index:\(indexPath.row):: \(selectedRecipes[indexPath.row].getName())")
        guard let customFont = UIFont(name: "SFCompactText-Regular", size: 20) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
            }
        cell.textLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        return cell
       }
    //allow editing rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return false
      }
    //selecting a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recId = selectedRecipes[indexPath.row].getId()
        let data = db.readSelectedRecipe(Id: Int(recId))
        if (data?.count != 0)  {
            if data![3] != "NULL"
            {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let filePath = documentsURL.appendingPathComponent("\(recId).png").path
                    if FileManager.default.fileExists(atPath: filePath) {
                        
                        self.recImg = UIImage(contentsOfFile: filePath)
                    }else{
                        self.recImg = UIImage(named: "default_photo.png")
                    }
        }else{
            self.recImg = UIImage(named: "default_photo.png")
            }
        }
        
    
        self.delegateVar?.sendRecipe(selectedRecipe: self.selectedRecipes[indexPath.row], selectedImg: self.recImg!, selectedCourse: self.selectedCourse )
      
        self.dismiss(animated: true, completion: nil)
                        
        
    }
    


   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

