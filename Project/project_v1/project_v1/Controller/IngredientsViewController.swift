//
//  IngredientsViewController.swift
//  project_v1
//
//  Created by Huda on 10/24/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

class IngredientsViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
   
    //View variables and functions
    let cellReuseIdentifier = "cell"
    
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var IngTabView: UITableView!
    @IBAction func add(_ sender: Any) {
         AddAlert()
    }
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    @IBAction func edit(_ sender: Any) {
        
        self.IngTabView.isEditing = !self.IngTabView.isEditing
            if self.IngTabView.isEditing
                {
                    self.editOutlet.title = "Done"
                } else{
                    self.editOutlet.title = "Edit"
                    

            }
    }
    
    //data variables
    var db:DBHelper = DBHelper()
    var ingredientsList:[ingredient] = []
    var filteredIngredients = [ingredient]()
   
    //loading and reloading
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //background:
      //  self.view.backgroundColor = UIColor(patternImage: UIImage(named: "blueBg.png")!)
  
        //configuring tableView:
        IngTabView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        IngTabView.delegate = self
        IngTabView.dataSource = self
        IngTabView.allowsSelectionDuringEditing = true
        IngTabView.layer.masksToBounds = true
        IngTabView.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 0.8 ).cgColor
        IngTabView.layer.borderWidth = 1.0
        IngTabView.isEditing = false
       
        
        //configuring searchbar
        searchBar.delegate = self
        ingredientsList = db.readIngredients()
        filteredIngredients = ingredientsList
        IngTabView.keyboardDismissMode = .onDrag
       }
        func reloadData(){
           DispatchQueue.main.async(execute: {self.IngTabView.reloadData()})
       }
       
        
    //setting tableviwe behavior
        
        //number of rows based on search
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
       {
               return filteredIngredients.count
       }
       // configuring cell's data and appearance
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
       {
           let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
            cell.textLabel?.text = filteredIngredients[indexPath.row].getName()
          
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
          return true
      }
    //selecting a row in edit mode makes it editable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if self.IngTabView.isEditing {
            let oldName = self.filteredIngredients[indexPath.row].getName()
            updateAlert(oldName: oldName)
        }
    }
    //deleting a row using the red icon
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        // Delete the row from the database
               let deletedId = filteredIngredients[indexPath.row].getId()
            
            if self.db.readSelectedIngRecipe(ingId: deletedId)?.count == 0 {
               
            if self.db.deleteByID(id: deletedId)
                {
                //delete data from data storage by reloading from database
                self.ingredientsList = self.db.readIngredients()
                
                //checking serach bar to display filtered ingredients accordingly
                    if searchBar.searchTextField.text!.isEmpty{
                        self.filteredIngredients = self.ingredientsList
                        
                    }else{
                
                        //updating filtered list after deletion
                        self.filteredIngredients = self.ingredientsList.filter({ (ingr) -> Bool in
                         let ingrText: NSString = NSString(string: ingr.getName())
                            return (ingrText.range(of: searchBar.searchTextField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                        })
                        
                    }
                //delete row from view
                self.IngTabView.deleteRows(at: [indexPath], with: .fade)
                    
                }else{
                    self.confirmAlert(title: "Failed", msg: " Deletion Failed. This Ingredient is included in a recipe or a database error occured")
                }
            
            }else{
                confirmAlert(title: "Deletion Not allowed", msg: "This ingredient cannot be deleted because it is included in a recipe")
            }
        }
    }
    
  //Alerts:
    //Addition Alert
    func AddAlert(){
        var added = ""
        let alert = UIAlertController(title: "Add Ingredient", message: "Note: Adding the same ingredeient with different names may lower the quality of search", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Ingredient's name"
        }
        //confirm addition
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
             added = textField.text!
            if self.db.insertIngredient(name: added)
            {
                self.confirmAlert(title: "Done" , msg: "\(added) Added")
                 self.reloadData()
             }
             else
            {
                self.confirmAlert(title: "Failed", msg: "\(added) Addition Failed. This Ingredient already exists or a database error occured")
             }
            self.ingredientsList = self.db.readIngredients()
            self.filteredIngredients = self.ingredientsList
        }))
        //cancel addition
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
           }))
        self.present(alert, animated: true, completion: nil)
    }
    //update alert
    func updateAlert(oldName: String){
        var newName = ""
        let alert = UIAlertController(title: " Edit Ingredient", message: "Note: Editing an ingredeient will change its name in all recipes", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = oldName
        }
        //confirm update
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
             newName = textField.text!
            if self.db.updateIngredient(newName: newName, oldName: oldName)
            {
                self.confirmAlert(title: "Done" , msg: "\(oldName) is changed to \(newName)")
                 self.reloadData()
             }
             else
            {
                self.confirmAlert(title: "Failed", msg: " changing \(oldName)'s name Failed. The new name already exists or a database error occured")
             }
            self.ingredientsList = self.db.readIngredients()
            self.filteredIngredients = self.ingredientsList
        }))
        //cancel update
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
           }))
        self.present(alert, animated: true, completion: nil)
    }

    //Confirmation of database change
    func confirmAlert(title: String, msg: String) {
          
           let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (_) in self.dismiss(animated: true, completion: nil)
           }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //searchbar behavior
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //filter data if searchbar has text otherwise use database order
        if searchText.isEmpty{
            filteredIngredients = ingredientsList
        }else{
        filteredIngredients = ingredientsList.filter({ (ingr) -> Bool in
         let ingrText: NSString = NSString(string: ingr.getName())
         return (ingrText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })}
        IngTabView.reloadData()
        
    }
   
    


}
