/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Facade
 - - - - - - - - - -
 ![Multicast Delegate Diagram](Facade_Diagram.png)
 
 The facade pattern is a structural pattern that provides a simple interface to a complex system. It involves two types:
 
 1. The **facade** provides simple methods to interact with the system. This allows consumers to use the facade instead of knowing about and interacting with multiple classes in the system.
 
 2. The **dependencies** are objects owned by the facade. Each dependency performs a small part of a complex task.
 
 ## Code Example
 */

import Foundation

// MARK: - Dependencies
public struct Customer {
    public let identifier: String
    public var address: String
    public var name: String
}

extension Customer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func ==(lhs: Customer, rhs: Customer) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public struct Product {
    public let identifier: String
    public var name: String
    public var cost: Double
}

extension Product: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    public static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public class InventoryDatabase {
    public var inventory: [Product: Int] = [:]
    
    public init(inventory: [Product: Int]) {
        self.inventory = inventory
    }
}

public class ShippingDatabase {
    public var pendingShipments: [Customer: [Product]] = [:]
}

// MARK: - Facade
public class OrderFacade {
    public let inventoryDatabase: InventoryDatabase
    public let shippingDatabase: ShippingDatabase
    
    init(inventoryDatabase: InventoryDatabase, shippingDatabase: ShippingDatabase) {
        self.inventoryDatabase = inventoryDatabase
        self.shippingDatabase = shippingDatabase
    }
    
    public func placeOrder(for product: Product, by customer: Customer) {
        print("Place order for '\(product.name)' by '\(customer.name)'")
        
        let count = inventoryDatabase.inventory[product, default: 0]
        
        guard count > 0 else {
            print("'\(product.name)' is out of stock!")
            return
        }
        
        inventoryDatabase.inventory[product] = count - 1
        var shipments = shippingDatabase.pendingShipments[customer, default: []]
        shipments.append(product)
        shippingDatabase.pendingShipments[customer] = shipments
        
        print("Order placed for '\(product.name)' by '\(customer.name)'")
    }
}

// MARK: - Example
let oreoOriginal = Product(identifier: "product-001", name: "Oreo Original Flavor", cost: 1.0)
let oreoMint = Product(identifier: "product-002", name: "Oreo Mint Flavor", cost: 1.3)
let oreoRedValvet = Product(identifier: "product-003", name: "Oreo RedValvet Flavor", cost: 1.5)

let inventoryDatabase = InventoryDatabase(
    inventory: [
        oreoOriginal: 100,
        oreoMint: 50,
        oreoRedValvet: 1
    ]
)

let orderFacade = OrderFacade(
    inventoryDatabase: inventoryDatabase,
    shippingDatabase: ShippingDatabase()
)

let simon = Customer(identifier: "customer-001", address: "505, Sinlimdong-gil 20, Seoul, ROK", name: "Simon")
let jin = Customer(identifier: "customer-002", address: "515, dang-san-ro 3 gil, Seoul, ROK", name: "Jin")

orderFacade.placeOrder(for: oreoRedValvet, by: simon)


