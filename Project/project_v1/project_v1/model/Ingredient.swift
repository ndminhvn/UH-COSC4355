//
//  Ingredients.swift
//  project_v1
//
//  Created by Huda on 10/24/20.
//  Copyright © 2020 Huda. All rights reserved.
//

import UIKit

class ingredient{
    
    private let id: Int
    private var name: String
    
    private static var count = 0
    
    init(id: Int,name: String){
        self.id = id
        self.name = name
    }
    
    func set(name: String){
        self.name = name
    }
    
    func getName() -> String{
        return self.name
    }
    
    func getId() -> Int{
        return self.id
    }
    
    public static func ingredientCount(){
        count = count + 1
    }
    
}
