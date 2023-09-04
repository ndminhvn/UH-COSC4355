//
//  main.swift
//  Exercise1_Nguyen_Minh
//
//  Created by Minh Nguyen on 8/27/23.
//

//import Foundation

/*
 Question 0:
 - With only if statement, greeting is "Hello!"
 - With else statement, greeting can be changed to something different, for example "Hey tell me your name!"
 */
var optionalString: String? = "Hello"
var optionalName: String?       //change to nil
//print(optionalName == nil)
var greeting = "Hello!";
if let name = optionalName {
    greeting = "Hello, \(name)"
}
else {
    greeting = "Hey tell me your name!"
}
print(greeting)

/*
 Question 1:
 
 */
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}

print(greet(person: "Bob", day: "Tuesday"))

func greet(_ person: String, _ day: String) -> String {
    return "Hello \(person), we have lunch special on \(day)."
}
print(greet("Bob", "Wednesday"))

/*
 Question 2:
 */
var numbers = [20, 19, 7, 12]
print(
    numbers.map({(number: Int) -> Int in
        if (number % 2 == 0) {
            return 0
        }
        return 1
    })
)

/*
 Question 3:
 */
class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Circle:NamedShape {
    var radius: Double
    
    init(name: String, radius: Double) {
        self.radius = radius
        super.init(name: name)
    }
    
    func circumference() -> Double {
        return 2 * Double.pi * radius
    }
    
    override func simpleDescription() -> String {
        return "A circle named \(name) with a radius of \(radius)."
    }
}

var circle = Circle(name: "Circle Test", radius: 10.5)
print(circle.simpleDescription() + " Its circumference is \(circle.circumference())")
