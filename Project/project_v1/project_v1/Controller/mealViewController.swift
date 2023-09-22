//
//  mealViewController.swift
//  project_v1
//
//  Created by Huda on 10/28/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit




class mealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MealTableViewCellDelegate{
    
    //cell delegate to connect buttons with ingeredients
    func didTabButtonOfIng(with id: Int, excludedState: String, includedState: String) {
        if excludedState == "active" {
            if !excludedIngredients.contains(id){
                excludedIngredients.append(id)
            }
        }else{
            if excludedIngredients.contains(id){
                if let index = excludedIngredients.firstIndex(of: id) {
                    excludedIngredients.remove(at: index)
                }
            }
        }
        
        if includedState == "active" {
            if !includedIngredients.contains(id){
                includedIngredients.append(id)
            }
        }else{
            if includedIngredients.contains(id){
                if let index = includedIngredients.firstIndex(of: id) {
                    includedIngredients.remove(at: index)
                }
            }
        }
    }
    
    //data variables

    var db:DBHelper = DBHelper()
    var ingredientsList:[ingredient] = []
    var filteredIngredients = [ingredient]()
    var selectedRecipes:[Int32] = []
    var includedRecipes:[Int32] = []
    var excludedRecipes:[Int32] = []
    var allRecId:[Int32] = []
    var includedIngredients:[Int] = []
    var excludedIngredients:[Int] = []
    var saladImg:UIImage?
    var soupImg:UIImage?
    var mainImg:UIImage?
    var dessertImg:UIImage?
    var resultSalads:[recipe] = []
    var resultMain:[recipe] = []
    var resultSoup:[recipe] = []
    var resultDessert:[recipe] = []
    
    //criteria switches
    @IBOutlet weak var sv: UIStackView!
    @IBOutlet weak var sv3: UIStackView!
    @IBOutlet weak var sv2: UIStackView!
    @IBOutlet weak var sv1: UIStackView!
    @IBOutlet weak var includeAllSwitch: UISwitch!
    @IBOutlet weak var excludeAllSwitch: UISwitch!
    @IBOutlet weak var IFFswicth: UISwitch!
    @IBAction func includeALL(_ sender: Any) {
        if includeAllSwitch.isOn
            {
                if excludeAllSwitch.isOn {
                excludeAllSwitch.isOn = false
            }
            if IFFswicth.isOn {
                IFFswicth.isOn = false
            }
            
        }
    }
    @IBAction func excludeALL(_ sender: Any) {
        if excludeAllSwitch.isOn
        {   if includeAllSwitch.isOn
            {
                includeAllSwitch.isOn = false
            }
        }
    }
    @IBAction func IFF(_ sender: Any) {
        if IFFswicth.isOn
        {   if includeAllSwitch.isOn
            {
                includeAllSwitch.isOn = false
            }
        }
    }
    
    //view
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var TabView: UITableView!
    let cellReuseIdentifier = "cell"
    
    //instruction
    @IBAction func help(_ sender: Any) {
        showAlert(title: "Instructions", msg: "The default setting is to show recipes containing at least one of the included ingredients but none of the excluded ingredients. Use the switches at the bottom to change the composition settings.")
    }
    
    
    //search for recipes
    @IBAction func done(_ sender: Any) {
        print (includedIngredients)
       print (excludedIngredients)
        
        //fetch recipe that has any of included ingredients
        for ingId in includedIngredients  {
            let recIds = db.readSelectedIngRecipe(ingId: ingId)
            if (recIds?.count != 0){
                self.includedRecipes += recIds!
            }
        }
        self.includedRecipes = Array(Set(self.includedRecipes))
        print("included")
        print(self.includedRecipes)
        
        //fetch recipe that has any of excluded ingredients
        for ingId in excludedIngredients  {
            let recIds = db.readSelectedIngRecipe(ingId: ingId)
            if (recIds?.count != 0){
                self.excludedRecipes += recIds!
            }
        }
        self.excludedRecipes = Array(Set(self.excludedRecipes))
        print("excluded")
        print(self.excludedRecipes)
        
        //first case (default-allswitches are off): select recipe that has at least one included ingredient but no excluded ingredient >> for picky allergic eaters
        if !(includeAllSwitch.isOn) && !(excludeAllSwitch.isOn) && !(IFFswicth.isOn){
            if includedIngredients.count == 0{
                showAlert(title:"No Included Ingredients", msg: "Please choose ingredients to include")
            }else{
                self.selectedRecipes = Array(Set(includedRecipes).subtracting(excludedRecipes))
                print("selected")
                print(self.selectedRecipes)
            }
            
        }
        //second case (first switch is on- others are off automatically):select recipe that has any included ingredient but no excluded ingredient >> for non_picky allergic eaters
        if (includeAllSwitch.isOn) {
            if excludedIngredients.count == 0{
                showAlert(title:"No Excluded ingerdients", msg: "Please choose ingredients to exclude")
            }else{
                let allRecipe = db.readRecipes()
                 for rec in allRecipe{
                     allRecId.append(Int32(rec.getId()))
                 }
                 self.selectedRecipes = Array(Set(allRecId).subtracting(excludedRecipes))
                 print("selected")
                 print(self.selectedRecipes)
            }
            
        }
        
        //third case (second switch is on and third switch is off):select recipe that has only included ingredient >> for cooking from pantry or extremely picky eater or only from pantry
        if (excludeAllSwitch.isOn) && !(IFFswicth.isOn) {
            if includedIngredients.count == 0{
                showAlert(title:"No included ingerdients", msg: "Please choose ingredients to include")
            }else{
               
                for recId in self.includedRecipes{
                    let ingData = db.readSelectedRecipeIng(Id:Int(recId))
                    if (ingData?.count != 0){
                        for ingId in ingData! {
                            if self.includedIngredients.contains(Int(ingId)){
                                continue
                            }else{
                                self.excludedRecipes.append(recId)
                                break
                            }
                        }
                    }
                 }
                 self.selectedRecipes = Array(Set(includedRecipes).subtracting(excludedRecipes))
                 print("selected")
                 print(self.selectedRecipes)
            }
            
        }
        
        //fourthcase (second switch is on and third switch is on):select recipe that has all included ingredient  and nothing else >> for finding recipe to use all current food items beforethey are wasted
        if (excludeAllSwitch.isOn) && (IFFswicth.isOn) {
            if includedIngredients.count == 0{
                showAlert(title:"No included ingerdients", msg: "Please choose ingredients to include")
            }else{
               
                for recId in self.includedRecipes{
                    let ingData = db.readSelectedRecipeIng(Id:Int(recId))
                    if (ingData?.count != 0){
                        if ingData!.count == includedIngredients.count
                        {
                            for ingId in ingData! {
                                if self.includedIngredients.contains(Int(ingId)){
                                    continue
                                }else{
                                    self.excludedRecipes.append(recId)
                                    break
                                }
                            }
                        }else{
                            self.excludedRecipes.append(recId)
                            
                        }
                    }
                 }
                 self.selectedRecipes = Array(Set(includedRecipes).subtracting(excludedRecipes))
                 print("selected")
                 print(self.selectedRecipes)
            }
            
        }
        
      
        //fifth case (tird switch is on while others are off):select recipe that has all included ingredient and none of the excluded ingredients >> for finding recipe based on loved combination or needed nutrition value
        if !(excludeAllSwitch.isOn) && (IFFswicth.isOn) {
            if includedIngredients.count == 0{
                showAlert(title:"No included ingerdients", msg: "Please choose ingredients to include")
            }else{
               
                for recId in self.includedRecipes{
                    let ingData = db.readSelectedRecipeIng(Id:Int(recId))
                    if (ingData?.count != 0){
                        for ingId in self.includedIngredients {
                            if ingData!.contains(Int32(ingId)){
                                continue
                            }else{
                                self.excludedRecipes.append(recId)
                                break
                            }
                        }
                    }
                 }
                 self.selectedRecipes = Array(Set(includedRecipes).subtracting(excludedRecipes))
                 print("selected")
                 print(self.selectedRecipes)
            }
            
        }
        DispatchQueue.global(qos: .userInitiated).async {
                self.categorizeRecipes()
            print(self.selectedRecipes)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "compose", sender: self)
                }
            }
        
       
    }
    
    
   


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //appearance
        buildBorder()
        
        
        //tableview
        TabView.delegate = self
        TabView.dataSource = self
       
        TabView.register(MealTableViewCell.nib(), forCellReuseIdentifier: MealTableViewCell.identifier)
        //searchbar
        searchBar.delegate = self
        ingredientsList = db.readIngredients()
        filteredIngredients = ingredientsList
        TabView.keyboardDismissMode = .onDrag
        
     
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.reloadData()
        ingredientsList = db.readIngredients()
        filteredIngredients = ingredientsList
       includedIngredients = []
      excludedIngredients = []
        includedRecipes = []
       excludedRecipes = []
        selectedRecipes = []
        includeAllSwitch.isOn = false
        excludeAllSwitch.isOn = false
        IFFswicth.isOn = false
        saladImg = nil
        soupImg = nil
        mainImg = nil
        dessertImg = nil
        resultSalads = []
        resultMain = []
        resultSoup = []
        resultDessert = []
        if includedIngredients.count > 0 {
            print ("appear:\(includedIngredients[0])")
        }
        if excludedIngredients.count > 0 {
            print ("appear:\(excludedIngredients[0])")
        }
        

    }

    //number of rows based on search
    
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
          {
                  return filteredIngredients.count
          }
          // configuring cell's data and appearance
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
          {
             
            let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as! MealTableViewCell
            let thisIngredient = filteredIngredients[indexPath.row]
            cell.delegate = self
            cell.configure(ing: thisIngredient,included: self.includedIngredients.contains(thisIngredient.getId()), excluded: self.excludedIngredients.contains(thisIngredient.getId()))
            
            
            return cell
          }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filter data if searchbar has text otherwise use database order
        if searchText.isEmpty{
            filteredIngredients = ingredientsList
        }else{
        filteredIngredients = ingredientsList.filter({ (ingr) -> Bool in
         let ingrText: NSString = NSString(string: ingr.getName())
         return (ingrText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })}
        TabView.reloadData()
    }
    
    func showAlert(title: String, msg: String) {
          
           let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (_) in self.dismiss(animated: true, completion: nil)
           }))
        self.present(alert, animated: true, completion: nil)
    }
    func reloadData(){
        DispatchQueue.main.async(execute: {self.TabView.reloadData()})
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "compose" {
            let next_view = segue.destination as! ResultMealViewController
            //next_view.selectedRecipes = self.selectedRecipes
            next_view.resultSalads = self.resultSalads
            next_view.resultSoup = self.resultSoup
            next_view.resultMain = self.resultMain
            next_view.resultDessert = self.resultDessert
            if (self.resultSalads.count > 0)
            {next_view.displayedSalad = self.resultSalads.last}
            if (self.resultSoup.count > 0)
            {next_view.displayedSoup = self.resultSoup.last}
            if (self.resultMain.count > 0)
            {next_view.displayedMain = self.resultMain.last}
            if (self.resultDessert.count > 0)
            {next_view.displayedDessert = self.resultDessert.last}
            next_view.saladImgSelected = self.saladImg
            next_view.soupImgSelected = self.soupImg
            next_view.mainImgSelected = self.mainImg
            next_view.dessertImgSelected = self.dessertImg
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    //borders around stacks
    func buildBorder(){
            let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
            TabView.layer.borderWidth = 2
        
            TabView.layer.borderColor = borderColor.cgColor
            sv.addBackground(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
           
        
        }
    
    
    func categorizeRecipes(){
        //recipe retreived data
        
        for recId in selectedRecipes {
            let data = db.readSelectedRecipe(Id: Int(recId))
            var recName: String = " "
            if (data?.count != 0)  {
                if data![0] != "NULL"
                { recName = data![0]}
                if data![3] != "NULL"
                {
                    if data![3] == "Salad"{
                        print("salad: \(recName)")
                        let rec = recipe(id: Int(recId), name: recName)
                        self.resultSalads.append(rec)
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let filePath = documentsURL.appendingPathComponent("\(recId).png").path
                        if FileManager.default.fileExists(atPath: filePath) {
                            
                            self.saladImg = UIImage(contentsOfFile: filePath)
                        }else{
                            self.saladImg = UIImage(named: "default_photo.png")
                        }
                    }else if data![3] == "Soup"{
                        let rec = recipe(id: Int(recId), name: recName)
                        self.resultSoup.append(rec)
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let filePath = documentsURL.appendingPathComponent("\(recId).png").path
                        if FileManager.default.fileExists(atPath: filePath) {
                            self.soupImg = UIImage(contentsOfFile: filePath)
                        }else{
                            self.soupImg = UIImage(named: "default_photo.png")
                        }
                    }else if data![3] == "Main Course"{
                        let rec = recipe(id: Int(recId), name: recName)
                        self.resultMain.append(rec)
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let filePath = documentsURL.appendingPathComponent("\(recId).png").path
                        if FileManager.default.fileExists(atPath: filePath) {
                            self.mainImg = UIImage(contentsOfFile: filePath)
                        }else{
                            self.mainImg = UIImage(named: "default_photo.png")
                        }
                    }else if data![3] == "Dessert"{
                        let rec = recipe(id: Int(recId), name: recName)
                        self.resultDessert.append(rec)
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let filePath = documentsURL.appendingPathComponent("\(recId).png").path
                        if FileManager.default.fileExists(atPath: filePath) {
                            self.dessertImg = UIImage(contentsOfFile: filePath)
                        }else{
                            self.dessertImg = UIImage(named: "default_photo.png")
                        }
                    }else{
                        continue
                    }
            }else{
                    continue
                }
            }
            
        }
        
        if self.saladImg == nil{
            self.saladImg = UIImage(named: "default_photo.png")
        }
        if self.soupImg == nil{
            self.soupImg = UIImage(named: "default_photo.png")
        }
        if self.mainImg == nil{
            self.mainImg = UIImage(named: "default_photo.png")
        }
        if self.dessertImg == nil{
            self.dessertImg = UIImage(named: "default_photo.png")
        }
    }
    
    

}

