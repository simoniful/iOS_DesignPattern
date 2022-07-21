import UIKit

// 1. Dog and Cat inherit from Animal, which defines an eat method
class Animal {
    func eat() {
        print("Eat")
    }
}

class Dog: Animal {}
class Cat: Animal {}

let chihuahua = Dog()
let bengalensis = Cat()

chihuahua.eat()
bengalensis.eat()


// 2. Vehicle protocol has one Motor and one or more Wheel objects

protocol Vehicle {
    var motor: Motor { get set }
    var wheel: Wheel { get set }
}

class Motor {}
class Wheel {}

// 3. Professor is a teacher and conforms to a Person protocol - vague!

protocol Person {}
class Teacher: Person {}
class Professor: Teacher {}

// protocol Person {}
// class Teacher {}
// class Professor: Teacher, Person {}
