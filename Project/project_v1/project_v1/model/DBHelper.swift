import Foundation
import UIKit
import SQLite3



class DBHelper
{
    
    init()
    {
        populateDB()
        db = openDatabase()
        createTableIngredients()
        createTableRecipes()
        createTableRecipes_Ingredients()
        
    }

    let dbPath: String = "myDb_final.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func dropTableRecipe() {
        
        let createTableString = "DROP TABLE Recipes;"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Recipes table dropped.")
            } else {
                print("recipes table could not be dropped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func dropTableIngredients() {
        
        let createTableString = "DROP TABLE Ingredients;"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Ingredients table dropped.")
            } else {
                print("Ingredients table could not be dropped.")
            }
        } else {
            print("DROP TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func createTableIngredients() {
        
        let createTableString = "CREATE TABLE IF NOT EXISTS Ingredients(Id INTEGER PRIMARY KEY,name TEXT NOT NULL);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Ingredients table created.")
            } else {
                print("Ingredients table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createTableRecipes() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Recipes(Id INTEGER PRIMARY KEY,name TEXT NOT NULL, url  TEXT, note TEXT, cat Text, img TEXT);"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Recipe table created.")
            } else {
                print("Recipe table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
   func createTableRecipes_Ingredients() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Recipes_Ingredients(ingId INTEGER NOT NULL REFERENCES Ingredients(Id) ,recID INTEGER NOT NULL REFERENCES Recipes(Id), PRIMARY KEY (ingID, recID)); "
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Recipe_Ingredient table created.")
            } else {
                print("Recipe_Ingredient table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    

    func insertIngredient(name:String) -> Bool
    {
        let Ingredients = readIngredients()
        for i in Ingredients
        {
            if i.getName() == name
            {
                return false
            }
        }
        let insertStatementString = "INSERT INTO Ingredients (name) VALUES ( ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            //sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not insert row.")
                sqlite3_finalize(insertStatement)
                return false
            }
        } else {
            print("INSERT statement could not be prepared.")
            sqlite3_finalize(insertStatement)
            return false
        }
        
    }
    
    func insertRecipe(name: String) -> Bool
        
    {
        let Recipes = readRecipes()
        for i in Recipes
        {
            if i.getName() == name
            {
                return false
            }
        }
        let insertStatementString = "INSERT INTO Recipes (name) VALUES ( ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            //sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not insert row.")
                sqlite3_finalize(insertStatement)
                return false
            }
        } else {
            print("INSERT statement could not be prepared.")
            sqlite3_finalize(insertStatement)
            return false
        }
        
    }
    
    func insertIngredientInRecipe(ingId: Int, recId: Int) -> Bool
    {
        
        let insertStatementString = "INSERT INTO Recipes_Ingredients (ingID, recID) VALUES ( ?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(ingId))
            sqlite3_bind_int(insertStatement, 2, Int32(recId))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                sqlite3_finalize(insertStatement)
                return true
            } else {
                print("Could not insert row.")
                sqlite3_finalize(insertStatement)
                return false
            }
        } else {
            print("INSERT statement could not be prepared.")
            sqlite3_finalize(insertStatement)
            return false
        }
        
    }
    
    
    
    func updateIngredient(newName:String, oldName: String) -> Bool
    {
        let Ingredients = readIngredients()
        for i in Ingredients
        {
            if i.getName() == newName
            {
                return false
            }
        }
        
        let updateStatementString = "UPDATE Ingredients SET name = ? WHERE name = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            //sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(updateStatement, 1, (newName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (oldName as NSString).utf8String, -1, nil)
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
                sqlite3_finalize(updateStatement)
                return true
            } else {
                print("Could not update row.")
                sqlite3_finalize(updateStatement)
                return false
            }
        } else {
            print("UPDATE statement could not be prepared.")
            sqlite3_finalize(updateStatement)
            return false
        }
        
    }
    
    func updateRecipe(Id: Int, newName:String,url:  String, note: String, cat: String, img: String ) -> Bool
    {
        _ = readRecipes()
       
        
        let updateStatementString = "UPDATE Recipes SET name = ?, url = ?, note = ?, cat = ?, img = ? WHERE Id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(updateStatement, 1, (newName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (url as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (note as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (cat as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (img as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 6, Int32(Id))
           
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
                sqlite3_finalize(updateStatement)
                return true
            } else {
                print("Could not update row.")
                sqlite3_finalize(updateStatement)
                return false
            }
        } else {
            print("UPDATE statement could not be prepared.")
            sqlite3_finalize(updateStatement)
            return false
        }
        
    }
    
    func readIngredients() -> [ingredient]  {
        
        let queryStatementString = "SELECT Id,name FROM Ingredients;"
        var queryStatement: OpaquePointer? = nil
        var Ingredients : [ingredient] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                //let year = sqlite3_column_int(queryStatement, 2)
                Ingredients.append(ingredient(id: Int(id), name: name))
               // print("Query Result:")
               // print("\(id) | \(name)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Ingredients
    }
    
    func readRecipes() -> [recipe]  {
        
        let queryStatementString = "SELECT * FROM Recipes;"
        var queryStatement: OpaquePointer? = nil
        var Recipes : [recipe] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                Recipes.append(recipe(id: Int(id), name: name))
               // print("Query Result:")
               // print("\(id) | \(name)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Recipes
    }
    
    func readSelectedRecipe(Id: Int) -> [String]?  {
        let queryStatementString = "SELECT * FROM Recipes Where Id = \(Id);"
        var queryStatement: OpaquePointer? = nil
        var data : [String] = ["NULL","NULL","NULL","NULL", "NULL"]
        var url:String
        var note: String
        var course: String
        var img: String
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                _ = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                data[0] = name
                if sqlite3_column_text(queryStatement, 2) != nil
                {  url = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    data[1] = url
                }
                if sqlite3_column_text(queryStatement, 3) != nil
                {  note = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                    data[2] = note
                }
                if sqlite3_column_text(queryStatement, 4) != nil
                {  course = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                    data[3] = course
                }
                if sqlite3_column_text(queryStatement, 5) != nil
                {  img = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                    data[4] = img
                }
                
               // print("Query Result:")
                //print(data)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return data
            
    }
    
    
    func readSelectedRecipeIng(Id: Int) -> [Int32]?  {
        let queryStatementString = "SELECT ingId FROM Recipes_Ingredients Where recId = \(Id);"
        var queryStatement: OpaquePointer? = nil
        var allIng : [Int32] = [Int32]()
        
        var ingId: Int32 = Int32()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if sqlite3_column_text(queryStatement, 0) != nil
                {       ingId = sqlite3_column_int(queryStatement, 0)
                        allIng.append(ingId)
                }

               // print("Query Result:")
               // print(ingId)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return allIng
            
    }
    func selectIng(ingId: Int32) -> ingredient?{
        let queryStatementString = "SELECT Id,name FROM Ingredients WHERE Id = \(ingId);"
        var queryStatement: OpaquePointer? = nil
        var Ingredient : ingredient?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                //let year = sqlite3_column_int(queryStatement, 2)
                Ingredient = (ingredient(id: Int(id), name: name))
                print("Query Result:")
                print("\(id) | \(name)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return Ingredient
    }
    func readSelectedIngRecipe(ingId: Int) -> [Int32]?  {
        let queryStatementString = "SELECT recId FROM Recipes_Ingredients Where ingId = \(ingId);"
        var queryStatement: OpaquePointer? = nil
        var allRec: [Int32] = [Int32]()
        
        var ingId: Int32 = Int32()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if sqlite3_column_text(queryStatement, 0) != nil
                {       ingId = sqlite3_column_int(queryStatement, 0)
                        allRec.append(ingId)
                }

                //print("Query Result:")
                //print(ingId)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return allRec
            
    }
    
    
    func deleteByID(id:Int) -> Bool {
        let deleteStatementStirng = "DELETE FROM Ingredients WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
                 sqlite3_finalize(deleteStatement)
                return true
            } else {
                print("Could not delete row.")
                 sqlite3_finalize(deleteStatement)
                return false
            }
        } else {
            print("DELETE statement could not be prepared")
             sqlite3_finalize(deleteStatement)
            return false
        }
       
    }
    
    func deleteByIDIngRec(recId:Int) -> Bool{
        let deleteStatementStirng = "DELETE FROM Recipes_Ingredients WHERE recId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(recId))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
                 sqlite3_finalize(deleteStatement)
                return true
            } else {
                print("Could not delete row.")
                 sqlite3_finalize(deleteStatement)
                return false
            }
        } else {
            print("DELETE statement could not be prepared")
             sqlite3_finalize(deleteStatement)
            return false
        }
        
    }
    func deleteByIDRec(id:Int) -> Bool {
        if deleteByIDIngRec(recId: id)
        {
        let deleteStatementStirng = "DELETE FROM Recipes WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
                 sqlite3_finalize(deleteStatement)
                return true
            } else {
                print("Could not delete row.")
                 sqlite3_finalize(deleteStatement)
                return false
            }
        } else {
            print("DELETE statement could not be prepared")
             sqlite3_finalize(deleteStatement)
            return false
        }
            
        }else{
            print("could not delete included ingredients")
            return false
        }
       
    }
    
    func populateDB(){
      
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".sqlite")
        copyFilesFromBundleToDocumentsFolderWith(fileExtension: ".png")
    }
    
    func copyFilesFromBundleToDocumentsFolderWith(fileExtension: String) {
        if let resPath = Bundle.main.resourcePath {
            do {
                let dirContents = try FileManager.default.contentsOfDirectory(atPath: resPath)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let filteredFiles = dirContents.filter{ $0.contains(fileExtension)}
                for fileName in filteredFiles {
                    if let documentsURL = documentsURL {
                        let sourceURL = Bundle.main.bundleURL.appendingPathComponent(fileName)
                        let destURL = documentsURL.appendingPathComponent(fileName)
                        do { try FileManager.default.copyItem(at: sourceURL, to: destURL) } catch { }
                    }
                }
            } catch { }
        }
    }
    
}
