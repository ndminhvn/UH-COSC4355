//
//  DetailRecipeViewController.swift
//  project_v1
//
//  Created by Huda on 10/28/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit


class DetailRecipeViewController: UIViewController, setIngPro, UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource, UITableViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func sendIngredients(selectedIngredient: ingredient?) {
        self.reloadData()

        if selectedIngredient != nil
        {
            self.selectedIngredients.append(selectedIngredient!)
            self.ingredients.append(selectedIngredient!.getName())
            self.IngTableView.reloadData()
            
        }
    }
    


    
    
    @IBOutlet weak var courseText: UITextField!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var IngTableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    let Categorypicker = UIPickerView()
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var done: UIBarButtonItem!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var doneEditText: UIBarButtonItem!
    @IBAction func doneEdit(_ sender: UIBarButtonItem) {
        
       self.isEditing = !self.isEditing
        if self.isEditing
             {
                    self.doneEditText.title = "Done"
                    self.IngTableView.reloadData()
                    self.IngTableView.isEditing = true
                    self.urlText.isHidden = false
                    self.urlTextView.isHidden = true
                    self.noteText.isUserInteractionEnabled = true
                    self.imgView.isUserInteractionEnabled = true
                    self.courseText.isUserInteractionEnabled = true
                    
                } else{
              self.doneEditText.title = "Edit"
                    
                    self.IngTableView.isEditing = false
                    self.IngTableView.reloadData()
                    self.urlText.isHidden = true
                    self.urlTextView.isHidden = false
                    self.urlTextView.isEditable = false
                    self.noteText.isUserInteractionEnabled = false
                    self.imgView.isUserInteractionEnabled = false
                    self.courseText.isUserInteractionEnabled = false
            }
        let recName = recipeName.text!
        let recUrl:String = urlText.text ?? "Null"
        urlTextView.text! =  urlText.text ?? " "
        let recNote:String = noteText.text ?? "Null"
        let recCat:String = courseText.text ?? "Null"
        var recImg: String = "Null"
        //to Save image in file
        if let image = originalImage {
            if originalImage != UIImage(named:"default_photo"){ do {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let fileURL = documentsURL.appendingPathComponent("\(selectedRec.getId()).png")
                    if let pngImageData = image.pngData() {
                    try pngImageData.write(to: fileURL, options: .atomic)
                        recImg = "\(fileURL)"
                    }
                } catch { print("error")}
            }
        }
        
        if db.updateRecipe(Id: selectedRec.getId(), newName: recName, url: recUrl, note: recNote, cat: recCat, img: recImg){
            print("ok")
        }else{print("couldnotUpdate")}
        if db.deleteByIDIngRec(recId: selectedRec.getId())
        {   for ing in selectedIngredients{
                if db.insertIngredientInRecipe(ingId: ing.getId(),recId: selectedRec.getId())
                {
                    print("\(ing.getName())ingredient added to recipe")}
        
            
        }
        }
       
    }
    
    var comingFrom = "RecipeView"
    var db:DBHelper = DBHelper()
    var selectedRec = recipe(id: 0, name: "dummy")
    var ingredients = ["Add"]
    var dummyIng = ingredient(id: -1,name: "dummy")
    var selectedIngredients:[ingredient] = []
    var pickerData: [String] = [String]()
    let cellReuseIdentifier = "cell"
    var originalImage = UIImage(named: "default_photo")
    var context = CIContext()
    let imgPicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       //appearance
       
        checkPrevious()
        buildBorder()
        if comingFrom != "result"
        {self.isEditing = true}
        print(selectedRec.getId())
        
        
        
        //recipe retreived data
        let data = db.readSelectedRecipe(Id: selectedRec.getId())
        if (data?.count != 0)  {
            if data![0] != "NULL"
            {self.recipeName.text! = data![0]}
            if data![1] != "NULL"
            {self.urlText.text! = data![1]
            self.urlTextView.text! = data![1]
            }
            if data![2] != "NULL"
            {self.noteText.text! = data![2]}
            if data![3] != "NULL"
            {self.courseText.text! = data![3]}
           
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
               let filePath = documentsURL.appendingPathComponent("\(selectedRec.getId()).png").path
                if FileManager.default.fileExists(atPath: filePath) {
                    self.imgView.image = UIImage(contentsOfFile: filePath)
                }else{print("no file exist")}
          
        }else{
            print("data == nil")
        }
        let ingData = db.readSelectedRecipeIng(Id:selectedRec.getId())
        if (ingData?.count != 0){
            for ingId in ingData! {
                let ing = db.selectIng(ingId: ingId)
                if ing != nil
                {self.selectedIngredients.append(ing!)
                    self.ingredients.append(ing!.getName())
                }
            }
        }
        if selectedIngredients.count > 0 {
            self.reloadData()
        }
        
  
    
        
        //Ingredients tableView
        IngTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        IngTableView.delegate = self
        IngTableView.dataSource = self
        IngTableView.allowsSelectionDuringEditing = true
        if comingFrom != "result"
        {IngTableView.isEditing = true}
        
       
        //Course Picker
        self.Categorypicker.delegate = self
        self.Categorypicker.dataSource = self
         pickerData = ["Pick a course","Salad", "Soup", "Main Course", "Dessert"]
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 255/255, green: 210/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        courseText.inputView = Categorypicker
        courseText.inputAccessoryView = toolBar
        
        //image picker
        imgPicker.delegate = self
        //tappingImage
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            
            imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        show_picker()

    }
    @objc func donePicker() {
        courseText.resignFirstResponder()
    }
    
    //image picker functions:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected an image, but was provided the following: \(info)")
        }
        
        imgView.image = selectedImage
        originalImage = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imgPicker.sourceType = .camera
            imgPicker.cameraCaptureMode = .photo
            present(imgPicker, animated: true, completion: nil)
        }else{
            showAlert(title: "Allow access to Camera", msg: "The app could not access your camera")
        }
    }
    func loadImageFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPicker.sourceType = .photoLibrary
            present(imgPicker, animated: true, completion: nil)
        }else{
            showAlert(title: "Allow access to Photo", msg: "The app could not access your photo gallery")
        }
    }
    func show_picker() {
        let alert = UIAlertController(title: "Picke Image for recipe", message: "Choose photo source", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Camera", comment: "Default action"), style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Open Gallery", comment: "Default action"), style: .default, handler: { _ in
            self.loadImageFromGallery()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func reloadData(){
       DispatchQueue.main.async(execute: {self.IngTableView.reloadData()})
   }
    
 
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
   
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 0 {courseText.text = pickerData[row]}
    }
    
    //number of rows based on search
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   {
           return ingredients.count
   }
  
    //height of cells:
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    
    var rowHeight:CGFloat = 0

    if(indexPath.row == 0) && !(self.isEditing){
            rowHeight = 0
        } else {
            rowHeight = 30    //or whatever you like
        }
        return rowHeight
    }
    
   // configuring cell's data and appearance
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
       let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = ingredients[indexPath.row]
      
    guard let customFont = UIFont(name: "SFCompactText-Regular", size: 15) else {
        fatalError("""
            Failed to load the "CustomFont-Light" font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    cell.textLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
    cell.textLabel?.adjustsFontForContentSizeCategory = true
        if indexPath.row == 0 && !(self.isEditing) {
            cell.isHidden = true
           } else {
            cell.isHidden = false
           }
           
    return cell
   }
    //allow editing rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row > 0)
        {
            return true
            
        }else{
            return false}
      }
    //selecting a row in edit mode makes it editable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "rec_ingPop", sender: self)
            
        }
       
    }
    //deleting a row using the red icon
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            self.ingredients.remove(at: indexPath.row)
            self.selectedIngredients.remove(at: indexPath.row-1)
        self.IngTableView.deleteRows(at: [indexPath], with: .fade)
         }
    }
    
    
    func buildBorder(){
      
            let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
            noteText.layer.borderWidth = 0.5
            noteText.layer.borderColor = borderColor.cgColor
            noteText.layer.cornerRadius = 7.0
            urlTextView.layer.borderWidth = 0.5
            urlTextView.layer.borderColor = borderColor.cgColor
            urlTextView.layer.cornerRadius = 7.0
        IngTableView.layer.borderWidth = 0.5
        IngTableView.layer.borderColor = borderColor.cgColor
        IngTableView.layer.cornerRadius = 7.0
        IngTableView.separatorInset = .zero
        
        }
    
    //to check the previous view and make this view avilable for ediiting accordingly
    func checkPrevious(){
        if self.comingFrom == "result"{
            self.isEditing = false
            self.doneEditText.isEnabled = false
            self.IngTableView.isEditing = false
            self.IngTableView.reloadData()
            self.urlText.isHidden = true
            self.urlTextView.isHidden = false
            self.urlTextView.isEditable = false
            self.noteText.isUserInteractionEnabled = false
            self.imgView.isUserInteractionEnabled = false
            self.courseText.isUserInteractionEnabled = false
            
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rec_ingPop" {
            let next_view = segue.destination as! RecIngPopViewController
            next_view.selectedIng = self.ingredients
            next_view.delegateVar = self
          
        }
    }
    
    
    func showAlert(title: String, msg: String) {
          
           let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {  (_) in self.dismiss(animated: true, completion: nil)
           }))
        self.present(alert, animated: true, completion: nil)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
     func supportedInterfaceOrientations() -> Int {
           return Int(UIInterfaceOrientationMask.portrait.rawValue)
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

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
