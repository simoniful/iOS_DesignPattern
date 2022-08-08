/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Flyweight
 - - - - - - - - - -
 ![Flyweight Diagram](Flyweight_Diagram.png)
 
 The Flyweight Pattern is a structural design pattern that minimizes memory usage and processing.
 
 The flyweight pattern provides a shared instance that allows other instances to be created too. Every reference to the class refers to the same underlying instance.
 
 ## Code Example
 */


import UIKit

// MARK: - Example 1

let red = UIColor.red
let red2 = UIColor.red

print(red === red2)

let color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
let color2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)

print(color === color2)

extension UIColor {
    public static var colorStore: [String: UIColor] = [:]
    public class func rgba(
        _ red: CGFloat,
        _ green: CGFloat,
        _ blue: CGFloat,
        _ alpha: CGFloat
    ) -> UIColor {
        let key = "\(red)\(green)\(blue)\(alpha)"
        if let color = colorStore[key] {
            return color
        }
        let color = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
        colorStore[key] = color
        return color
    }
}

let flyColor = UIColor.rgba(1, 0, 0, 1)
let flyColor2 = UIColor.rgba(1, 0, 0, 1)

print(flyColor === flyColor2)

// MARK: - Example 2

// Flyweight
class BulletFlyweight {
    // Operation
    // Extrinsic state
    let color: String
    let size: CGFloat
    
    init(color: String, size: CGFloat) {
        self.color = color
        self.size = size
    }
}

// Unshared Concrete Flyweight
class Bullet {
    // Intrinsic State
    var x: CGFloat
    var y: CGFloat
    var velocity: CGFloat
    
    // Concrete Flyweight
    private var extrinsicState: BulletFlyweight
    
    init(x: CGFloat, y: CGFloat, velocity: CGFloat, extrinsicState: BulletFlyweight) {
        self.x = x
        self.y = y
        self.velocity = velocity
        self.extrinsicState = extrinsicState
    }
    
    func getState() {
        print("Flyweight : \(x),\(y),\(velocity) 값을 갖는 \(extrinsicState.color), \(extrinsicState.size) 총알")
    }
}

// Flyweight Factory
class BulletFlyweightFactory {
    static private var bulletFlyweightList: [BulletFlyweight] = []
    
    // GetFlyweight(repeating state)
    static func getBulletFlyweight(color: String, size: CGFloat) -> BulletFlyweight {
        if let flyweightIndex = self.bulletFlyweightList.firstIndex(where: { (bullet) -> Bool in
            return bullet.color == color && bullet.size == size
        }) {
            return self.bulletFlyweightList[flyweightIndex]
        } else {
            self.bulletFlyweightList.append(BulletFlyweight(color: color, size: size))
            print("\(color),\(size) Flyweight 객체 생성")
            return self.bulletFlyweightList.last ?? BulletFlyweight(color: color, size: size)
        }
    }
    
    static var flyweightCount: Int {
        return self.bulletFlyweightList.count
    }
    
    private init() {}
}

var bullets: [Bullet] = []

for i in 0..<5 {
    let i = CGFloat(i)
    bullets.append(
        Bullet(
            x: i,
            y: i,
            velocity: i * 5,
            extrinsicState: BulletFlyweightFactory.getBulletFlyweight(
                color: "Gold",
                size: 5.56
            )
        )
    )
}

for i in 0..<7 {
    let i = CGFloat(i)
    bullets.append(
        Bullet(
            x: i,
            y: i,
            velocity: i * 7,
            extrinsicState: BulletFlyweightFactory.getBulletFlyweight(
                color: "Silver",
                size: 7.62
            )
        )
    )
}

print("Flyweight 객체 수: \(BulletFlyweightFactory.flyweightCount)")





