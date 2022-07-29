/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Prototype
 - - - - - - - - - -
 ![Prototype Diagram](Prototype_Diagram.png)
 
 The prototype pattern is a creational pattern that allows an object to copy itself. It involves two types:
 
 1. A **copying** protocol declares copy methods.
 
 2. A **prototype** is a class that conforms to the copying protocol.
 
 ## Code Example
 */

import Foundation

public protocol Prototype: AnyObject {
    init(_ prototype: Self)
}
extension Prototype {
    public func copy() -> Self {
        return type(of: self).init(self)
    }
}

public class Monster: Prototype {
    public var health: Int
    public var level: Int
    public init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }
    public required convenience init(_ prototype: Monster) {
        self.init(health: prototype.health, level: prototype.level)
    }
}

public class EyeballMonster: Monster {
    public var redness = 0
    public override convenience init(health: Int, level: Int) {
        self.init(health: health, level: level, redness: 0)
    }
    public init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }
    
    @available(*, unavailable, message: "Call copy() instead")
    public required convenience init(_ prototype: Monster) {
        let eyeballMonster = prototype as! EyeballMonster
        self.init(health: eyeballMonster.health,
                  level: eyeballMonster.level,
                  redness: eyeballMonster.redness)
    }
}

let monster = Monster(health: 700, level: 37)
let monster2 = monster.copy()
print("Watch out! That monster's level is \(monster2.level)")

let eyeballMonster = EyeballMonster(health: 3000, level: 60, redness: 999)
let eyeballMonster2 = eyeballMonster.copy()
print("Eww! It's eyeball redness is \(eyeballMonster2.redness)!")

// let eyeballMonster3 = EyeballMonster(monster)
