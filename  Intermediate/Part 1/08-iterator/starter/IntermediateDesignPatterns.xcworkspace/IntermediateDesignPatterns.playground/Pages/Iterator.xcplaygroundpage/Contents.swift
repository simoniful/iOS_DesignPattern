/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Iterator
 - - - - - - - - - -
 ![Iterator Diagram](Iterator_Diagram.png)
 
 The Iterator Pattern provides a standard way to loop through a collection. This pattern involves two types:
 
 1. The Swift `Iterable` protocol defines a type that can be iterated using a `for in` loop.
 
 2. A **custom object** you want to make iterable. Instead of conforming to `Iterable` directly, however, you can conform to `Sequence`, which itself conforms to `Iterable`. By doing so, you'll get many higher-order functions, including `map`, `filter` and more, implemented for free for you.
 
 ## Code Example
 */

import Foundation

// Example 1 - Iterator supported in Swift
// Iterator Object
public struct Queue<T> {
    private var array: [T?] = []
    private var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count,
        let element = array[head] else {
            return nil
        }
        array[head] = nil
        head += 1
        let percentage = Double(head) / Double(array.count)
        if array.count > 50,
           percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
}

// IteratorProtocol
extension Queue: Sequence {
    public func makeIterator() -> IndexingIterator<Array<T>> {
        let nonEmptyValues = Array(array[head ..< array.count]) as! [T]
        return nonEmptyValues.makeIterator()
    }
}

// Model
public struct Ticket {
    enum PriorityType {
        case low
        case medium
        case high
    }
    var description: String
    var priority: PriorityType
}

extension Ticket {
    var sortIndex: Int {
        switch self.priority {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        }
    }
}

var queue = Queue<Ticket>()
queue.enqueue(Ticket(description: "디자인 패턴 정리하기", priority: .medium))
queue.enqueue(Ticket(description: "데이터 스트럭쳐 정리하기", priority: .high))
queue.enqueue(Ticket(description: "포트폴리오 정리하기", priority: .low))
queue.enqueue(Ticket(description: "이력서 정리하기", priority: .medium))

print("List of Tickets in queue:")
for ticket in queue {
    print(ticket.description)
}

let sortedTickets = queue.sorted {
    $0.sortIndex > $1.sortIndex
}
print("\nSorted Tickets in queue:")
for ticket in sortedTickets {
    print(ticket.description)
}

// Example 2 - Custom Iterator
// Iterable Interface
protocol Iterable {
    associatedtype Iterator
    func makeIterator() -> Iterator
}

// Iterator Interface
protocol Iterator {
    associatedtype Element
    func first() -> Element?
    func currentItem() -> Element?
    func next() -> Element?
    func hasNext() -> Bool
}

// Concrete Iterator
final class defaultIterator<T>: Iterator {
    typealias Element = T
    private var items: [Element] = []
    private var current = 0
 
    init(items: [Element]) {
        self.items = items
    }
    
    func first() -> Element? {
        guard items.count != 0 else { return nil }
        return items[0]
    }
    
    func currentItem() -> Element? {
        guard items.count != 0 else { return nil }
        return items[current]
    }
 
    func next() -> Element? {
        guard hasNext() else { return nil }
        defer { self.current += 1 }
 
        return items[current]
    }
 
    func hasNext() -> Bool {
        current < items.count
    }
}

// Concrete iterable
final class MapCollection: Iterable {
    private var map: [String: String] = [:]
 
    func add(element: String, for key: String) {
        map.updateValue(element, forKey: key)
    }
 
    func makeIterator() -> defaultIterator<String> {
        return defaultIterator<String>(items: self.map.values.map({ $0 }))
    }
}

// Concrete iterable
final class ListCollection: Iterable {
    private var list: [String] = []
 
    func add(element: String) {
        list.append(element)
    }
 
    func makeIterator() -> defaultIterator<String> {
        return defaultIterator<String>(items: self.list)
    }
}


let map = MapCollection()
let list = ListCollection()
 
map.add(element: "1", for: "1")
map.add(element: "2", for: "2")
map.add(element: "3", for: "3")
 
list.add(element: "11")
list.add(element: "22")
list.add(element: "33")
 
let iterators = [map.makeIterator(), list.makeIterator()]
 
for iterator in iterators {
    while iterator.hasNext() {
        print(iterator.next() ?? "0")
    }
}



