//
//  RecipesViewController.swift
//  project_v1
//
//  Created by Huda on 10/27/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {

      //View variables and functions
      let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var IngTabView: UITableView!
      
    @IBAction func add(_ sender: Any) {
        AddAlert()
    }
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    @IBAction func edit(_ sender: UIBarButtonItem) {
     
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
      var RecipesList:[recipe] = []
      var filteredRecipes = [recipe]()
    var selectedRec: recipe = recipe(id: 0,name: "dummy")
     
      //loading and reloading
      override func viewDidLoad() {
          super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "yellowBg.png")!)
        self.IngTabView.isEditing = false
          //configuring tableView:
        self.IngTabView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.IngTabView.delegate = self
        self.IngTabView.dataSource = self
        self.IngTabView.allowsSelectionDuringEditing = true
        self.IngTabView.allowsSelection = true
        self.IngTabView.layer.masksToBounds = true
        self.IngTabView.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 0.8 ).cgColor
        self.IngTabView.layer.borderWidth = 1.0
        self.IngTabView.isEditing = false
                 
          
          //configuring searchbar
          searchBar.delegate = self
          RecipesList = db.readRecipes()
          filteredRecipes = RecipesList
          IngTabView.keyboardDismissMode = .onDrag
         
         }
          func reloadData(){
             DispatchQueue.main.async(execute: {self.IngTabView.reloadData()})
         }
    override func viewDidAppear(_ animated: Bool) {
        self.reloadData()
        RecipesList = db.readRecipes()
        filteredRecipes = RecipesList
    }
          
      //setting tableviwe behavior
          
          //number of rows based on search
          func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
         {
                 return filteredRecipes.count
         }
         // configuring cell's data and appearance
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
         {
             let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
              cell.textLabel?.text = filteredRecipes[indexPath.row].getName()
            
            
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
        self.selectedRec =  filteredRecipes[indexPath.row]
        performSegue(withIdentifier: "rec_ed", sender: self)
          
      }
      //deleting a row using the red icon
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
          // Delete the row from the database
                 let deletedId = filteredRecipes[indexPath.row].getId()
                 
              if self.db.deleteByIDRec(id: deletedId)
                  {
                      //delete data from data storage by reloading data from database
                      self.RecipesList = self.db.readRecipes()
                
                    //checking searchbar to display filtered ingredients accordingly
                    if searchBar.searchTextField.text!.isEmpty{
                      self.filteredRecipes = self.RecipesList
                        
                    }else{
                        print("here")
                        //updating filtered list after deletion according to the serach bar content
                        self.filteredRecipes = self.RecipesList.filter({ (ingr) -> Bool in
                         let ingrText: NSString = NSString(string: ingr.getName())
                            return (ingrText.range(of: searchBar.searchTextField.text!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                        })
                        
                    }
                //delete row from view
                self.IngTabView.deleteRows(at: [indexPath], with: .fade)
                
                
                  // Get destination url in document directory for file
                  guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                  let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent("\(deletedId).png")

                  // Delete file in document directory
                  if FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
                      do {
                          try FileManager.default.removeItem(at: documentDirectoryFileUrl)
                      } catch {
                          print("Could not delete file: \(error)")
                      }
                  }
                }else{
                    self.confirmAlert(title: "Failed", msg: " Deletion Failed.  database error occured")
                }
          }
      }
      
    //Alerts:
      //Addition Alert
      func AddAlert(){
          var added = ""
          let alert = UIAlertController(title: "Add Recipe", message: "Enter recipe's Name,then click the recipe to add other details", preferredStyle: .alert)
          alert.addTextField { (textField) in
              textField.placeholder = "Recipe's name"
          }
          //confirm addition
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
              let textField = alert!.textFields![0]
               added = textField.text!
                                            if added.count > 0{
              if self.db.insertRecipe(name: added)
              {
                  self.confirmAlert(title: "Done" , msg: "\(added) Added")
                   self.reloadData()
               }
               else
              {
                  self.confirmAlert(title: "Failed", msg: "\(added) Addition Failed. This recipe already exists or a database error occured")
               }
              self.RecipesList = self.db.readRecipes()
              self.filteredRecipes = self.RecipesList
            
            } else{
                self.confirmAlert(title: "Failed", msg: " Recipe'sname cannot be Empty")
                }
            
          }))
          //cancel addition
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
              filteredRecipes = RecipesList
          }else{
          filteredRecipes = RecipesList.filter({ (ingr) -> Bool in
           let ingrText: NSString = NSString(string: ingr.getName())
           return (ingrText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
          })}
          IngTabView.reloadData()
      }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "rec_ed" {
            let detail_view = segue.destination as! DetailRecipeViewController
            detail_view.selectedRec = self.selectedRec
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
