//
//  RecIngPopViewController.swift
//  project_v1
//
//  Created by Huda on 11/26/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

protocol setIngPro {
    func sendIngredients(selectedIngredient: ingredient?)
}

class RecIngPopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
        //View variables and functions
        let cellReuseIdentifier = "cell"
        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var IngTabView: UITableView!
 
        //data variables
        var db:DBHelper = DBHelper()
        var ingredientsList:[ingredient] = []
        var filteredIngredients = [ingredient]()
        var recipeIngredients:[ingredient] = []
        var selectedIng:[String] = []
  
    
    //delegate
    var delegateVar: setIngPro?
    
      
       
        //loading and reloading
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
        
      
            //configuring tableView:
            IngTabView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            IngTabView.delegate = self
            IngTabView.dataSource = self
     
                   
            
            //configuring searchbar
            searchBar.delegate = self
            ingredientsList = db.readIngredients()
            filteredIngredients = ingredientsList
           
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
              return false
          }
        //selecting a row 
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if !selectedIng.contains(filteredIngredients[indexPath.row].getName())
            {
                self.delegateVar?.sendIngredients(selectedIngredient: filteredIngredients[indexPath.row])
                self.dismiss(animated: true, completion: nil)
                
            }else{
                showAlert(title:"This ingredient has already beeen added", msg:"")
            }
            
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
    func showAlert(title: String, msg: String) {
          
           let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (_) in self.dismiss(animated: true, completion: nil)
           }))
        self.present(alert, animated: true, completion: nil)
    }
       
      
    }

