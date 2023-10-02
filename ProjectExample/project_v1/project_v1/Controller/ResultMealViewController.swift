//
//  ResultMealViewController.swift
//  project_v1
//
//  Created by Huda on 10/28/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

class ResultMealViewController: UIViewController,setRecPro {
    func sendRecipe(selectedRecipe: recipe?, selectedImg: UIImage, selectedCourse: String) {
        
        

        if selectedRecipe != nil
        {
            if selectedCourse == "Salad"{
                displayedSalad = selectedRecipe
                saladLbl.text! = selectedRecipe!.getName()
                saladImg.image! = selectedImg
            }
            if selectedCourse == "Soup"{
                displayedSoup = selectedRecipe
                soupLbl.text! = selectedRecipe!.getName()
                soupImg.image! = selectedImg
            }
            if selectedCourse == "Main Course"{
                displayedMain = selectedRecipe
                mainLbl.text! = selectedRecipe!.getName()
                mainImg.image! = selectedImg
            }
            if selectedCourse == "Dessert"{
                displayedDessert = selectedRecipe
                DessertLbl.text! = selectedRecipe!.getName()
                dessertImg.image! = selectedImg
            }
            
        }
    }
    
    
  
    @IBOutlet weak var dessertStack: UIStackView!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var soupStack: UIStackView!
    @IBOutlet weak var saladStack: UIStackView!
    
    
    
    
    @IBOutlet weak var saladImg: UIImageView!
    @IBOutlet weak var soupImg: UIImageView!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var dessertImg: UIImageView!
    
    
    
    @IBOutlet weak var saladLbl: UILabel!
    @IBOutlet weak var soupLbl: UILabel!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var DessertLbl: UILabel!
    
    @IBOutlet weak var moreSalad: UIButton!
    @IBOutlet weak var moreSoup: UIButton!
    @IBOutlet weak var moreMain: UIButton!
    @IBOutlet weak var moreDessert: UIButton!
    
    @IBAction func shuffle(_ sender: Any) {
        
        if resultSalads.count>1
        {
            displayedSalad = resultSalads[Int.random(in:0...resultSalads.count-1)]
            self.saladLbl.text! = self.displayedSalad!.getName()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("\(displayedSalad!.getId()).png").path
            if FileManager.default.fileExists(atPath: filePath) {
                self.saladImgSelected = UIImage(contentsOfFile: filePath)
            }else{
                self.saladImgSelected = UIImage(named: "default_photo.png")
            }
        }
        if resultSoup.count>1
        {
            displayedSoup = resultSoup[Int.random(in:0...resultSoup.count-1)]
            self.soupLbl.text! = self.displayedSoup!.getName()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("\(displayedSoup!.getId()).png").path
            if FileManager.default.fileExists(atPath: filePath) {
                self.soupImgSelected = UIImage(contentsOfFile: filePath)
            }else{
                self.soupImgSelected = UIImage(named: "default_photo.png")
            }
        }
        if resultMain.count > 1
        {
            displayedMain = resultMain[Int.random(in:0...resultMain.count-1)]
            self.mainLbl.text! = self.displayedMain!.getName()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("\(displayedMain!.getId()).png").path
            if FileManager.default.fileExists(atPath: filePath) {
                self.mainImgSelected = UIImage(contentsOfFile: filePath)
            }else{
                self.mainImgSelected = UIImage(named: "default_photo.png")
            }
        }
        if resultDessert.count > 1
        {
            displayedDessert = resultDessert[Int.random(in:0...resultDessert.count-1)]
            self.DessertLbl.text! = self.displayedDessert!.getName()
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("\(displayedDessert!.getId()).png").path
            if FileManager.default.fileExists(atPath: filePath) {
                self.dessertImgSelected = UIImage(contentsOfFile: filePath)
            }else{
                self.dessertImgSelected = UIImage(named: "default_photo.png")
            }
        }
        
        
        self.saladImg.image = self.saladImgSelected
        self.soupImg.image = self.soupImgSelected
        self.mainImg.image = self.mainImgSelected
        self.dessertImg.image = self.dessertImgSelected
        
        
        
        
        
        
    }
    @IBAction func moreS(_ sender: Any) {
        self.pickedCourse = "Salad"
        self.pickedRecipe = resultSalads
        self.performSegue(withIdentifier: "moreSalad", sender: self)
    }
    @IBAction func moreSp(_ sender: Any) {
        self.pickedCourse = "Soup"
        self.pickedRecipe = resultSoup
        self.performSegue(withIdentifier: "moreSoup", sender: self)

    }
    @IBAction func moreM(_ sender: Any) {
        self.pickedCourse = "Main Course"
        self.pickedRecipe = resultMain
        self.performSegue(withIdentifier: "moreMain", sender: self)

    }
    @IBAction func moreD(_ sender: Any) {
        self.pickedCourse = "Dessert"
        self.pickedRecipe = resultDessert
        self.performSegue(withIdentifier: "moreDessert", sender: self)

    }
    
    var displayedSalad:recipe?
    var displayedSoup:recipe?
    var displayedMain:recipe?
    var displayedDessert:recipe?
    var saladImgSelected:UIImage?
    var soupImgSelected:UIImage?
    var mainImgSelected:UIImage?
    var dessertImgSelected:UIImage?
   // var selectedRecipes:[Int32] = []
    var pickedCourse: String = ""
    var pickedRecipe: [recipe] = []
    var resultSalads:[recipe] = []
    var resultMain:[recipe] = []
    var resultSoup:[recipe] = []
    var resultDessert:[recipe] = []
    var selectedCourse: String = " "
    var tappedRecipe: recipe?
    var db:DBHelper = DBHelper()
    
    override func viewDidLoad() {
       
       
        
        super.viewDidLoad()
        buildBorder()
        
        self.saladImg.image = self.saladImgSelected
        self.soupImg.image = self.soupImgSelected
        self.mainImg.image = self.mainImgSelected
        self.dessertImg.image = self.dessertImgSelected
            if self.resultSalads.count>0{
                print("s")
               print( self.resultSalads[0].getName())
                self.saladLbl.text! = self.displayedSalad!.getName()
             }else{
                self.saladLbl.text! = "No Recipes for this course"
             }
             
             if self.resultSoup.count>0{
                print(self.resultSoup[0].getName())
                
                self.soupLbl.text! = self.displayedSoup!.getName()
             }else{
                self.soupLbl.text! = "No Recipes for this course"
             }
             
             if self.resultMain.count>0{
                
                self.mainLbl.text! = self.displayedMain!.getName()
             }else{
                self.mainLbl.text! = "No Recipes for this course"
             }
             
             if self.resultDessert.count>0{
                
                self.DessertLbl.text! = self.displayedDessert!.getName()
             }else{
                self.DessertLbl.text! = "No Recipes for this course"
             }
      
   //tapping images
     let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
     if displayedSalad != nil
     {saladImg.isUserInteractionEnabled = true
         saladImg.addGestureRecognizer(tapGestureRecognizer1)}
     let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
     if displayedSoup != nil
     {soupImg.isUserInteractionEnabled = true
         soupImg.addGestureRecognizer(tapGestureRecognizer2)}
     let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
     if displayedMain != nil
     {   print ("from tap")
         mainImg.isUserInteractionEnabled = true
         mainImg.addGestureRecognizer(tapGestureRecognizer3)}
     let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
     if displayedDessert != nil
     {dessertImg.isUserInteractionEnabled = true
         dessertImg.addGestureRecognizer(tapGestureRecognizer4)}
     
     //tapping recipeName
     let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(stackTapped(tapGestureRecognizer:)))
     if displayedSalad != nil
     {saladStack.isUserInteractionEnabled = true
         saladStack.addGestureRecognizer(tapGestureRecognizer5)}
     let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(stackTapped(tapGestureRecognizer:)))
     if displayedSoup != nil
     {soupStack.isUserInteractionEnabled = true
         soupStack.addGestureRecognizer(tapGestureRecognizer6)}
     let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(stackTapped(tapGestureRecognizer:)))
     if displayedMain != nil
     {   print ("from tap")
         mainStack.isUserInteractionEnabled = true
         mainStack.addGestureRecognizer(tapGestureRecognizer7)}
     let tapGestureRecognizer8 = UITapGestureRecognizer(target: self, action: #selector(stackTapped(tapGestureRecognizer:)))
     if displayedDessert != nil
     {dessertImg.isUserInteractionEnabled = true
         dessertStack.addGestureRecognizer(tapGestureRecognizer8)}
       
    }

    override func viewWillAppear(_ animated: Bool) {
        
      
                
               
  
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imageTapped = tapGestureRecognizer.view as! UIImageView
        if imageTapped == saladImg
        {   self.tappedRecipe = displayedSalad
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}
        if imageTapped == soupImg
        {   self.tappedRecipe = displayedSoup
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}
        if imageTapped == mainImg
        {   self.tappedRecipe = displayedMain
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}
        if imageTapped == dessertImg
        {   self.tappedRecipe = displayedDessert
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}

    }
    
    @objc func stackTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let labelTapped = tapGestureRecognizer.view as! UIStackView
        if labelTapped == saladStack
        {   self.tappedRecipe = displayedSalad
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}
        if labelTapped == soupStack
        {   self.tappedRecipe = displayedSoup
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}
        if labelTapped == mainStack
        {   self.tappedRecipe = displayedMain
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}
        if labelTapped == dessertStack
        {   self.tappedRecipe = displayedDessert
            self.performSegue(withIdentifier: "to_selectedRec", sender: self)}

    }
    
      
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moreSalad") || (segue.identifier == "moreSoup") || (segue.identifier == "moreMain") || (segue.identifier == "moreDessert") {
            let morePage = segue.destination as! ExtrasMealViewController
            morePage.selectedCourse = pickedCourse
            morePage.selectedRecipes = pickedRecipe
            morePage.delegateVar = self
        }
        
        if segue.identifier == "to_selectedRec" {
            let detailPage = segue.destination as! DetailRecipeViewController
            detailPage.comingFrom = "result"
            detailPage.selectedRec = tappedRecipe!
        }
    }
   
    func buildBorder(){
        dessertStack.addBackground(color:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        mainStack.addBackground(color:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        soupStack.addBackground(color:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        saladStack.addBackground(color:#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        }
    

    
    
   

}
extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.alpha = 0.8
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        subView.layer.borderWidth = 1
        subView.layer.borderColor = borderColor.cgColor
        subView.layer.cornerRadius = 7.0
    }
    
}
