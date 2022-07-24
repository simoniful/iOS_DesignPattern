/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Observer
 - - - - - - - - - -
 ![Observer Diagram](Observer_Diagram.png)
 
 The observer pattern allows "observer" objects to register for and receive updates whenever changes are made to "subject" objects.
 
 This pattern allows us to define "one-to-many" relationships between many observers receiving updates from the same subject.
 
 ## Code Example
 */

// MARK: - Example. 1
import Combine

public class User {
    @Published var name: String
    
    public init (name: String) {
        self.name = name
    }
}

let user = User(name: "Simon")
let publisher = user.$name

var subscriber: AnyCancellable? = publisher.sink() {
    print("User's name is \($0)")
}

user.name = "Jin"

subscriber = nil
user.name = "Lee"


// MARK: - Example. 2
protocol Observer {
    var id: String { get set }
    func update(message: String)
}

protocol Publisher {
    var observers: [Observer] { get set }
    func subscribe(observer: Observer)
    func unSubscribe(observer: Observer)
    func notify(message: String)
}

class AppleStore: Publisher {
    var observers: [Observer]
    
    init(observers: [Observer]) {
        self.observers = observers
    }
    
    func subscribe(observer: Observer) {
        self.observers.append(observer)
    }
    
    func unSubscribe(observer: Observer) {
        if let index = self.observers.firstIndex(where: { $0.id == observer.id }) {
            self.observers.remove(at: index)
        }
    }
    
    func notify(message: String) {
        for observer in observers {
            observer.update(message: message)
        }
    }
}

class Customer: Observer {
    var id: String
    init(id: String) {
        self.id = id
    }
    func update(message: String) {
        print("\(id)님 \(message)수신\n")
    }
}

let appleStore = AppleStore(observers: [])
let pingu = Customer(id: "Pingu")
let pinga = Customer(id: "Pinga")
let roby = Customer(id: "Roby")
let ick = Customer(id: "Ick")

appleStore.subscribe(observer: pingu)
appleStore.subscribe(observer: roby)

appleStore.notify(message: "iPhone 재고 입고!")

appleStore.unSubscribe(observer: roby)
appleStore.notify(message: "iPad 재고 입고!")


