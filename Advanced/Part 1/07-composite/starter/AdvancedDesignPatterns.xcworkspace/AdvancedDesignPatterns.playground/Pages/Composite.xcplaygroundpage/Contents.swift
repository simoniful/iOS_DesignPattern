/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Composite
 - - - - - - - - - -
 ![Composite Diagram](Composite_Diagram.png)
 
 The composite pattern is a structural pattern that groups a set of objects into a tree so that they may be manipulated as though they were one object. It uses three types:
 
 1. The **component protocol** ensures all constructs in the tree can be treated the same way.
 2. A **leaf** is a component of the tree that does not have child elements.
 3. A **composite** is a container that can hold leaf objects and composites.
 
 ## Code Example
 */
import Foundation

public protocol File {
    var name: String { get set }
    func open()
}

struct eBook: File {
    var name: String
    var author: String
    
    func open() {
        print("\(author)의 \(name) iBooks에서 열림")
    }
}

struct Music: File {
    var name: String
    var artist: String
    
    func open() {
        print("\(artist)의 \(name) AppleMusic에서 재생")
    }
}

struct Folder: File {
    var name: String
    var files: [File] = []
    
    mutating func addFile(_ file: File) {
        self.files.append(file)
    }
    
    func open() {
        print("\(name) 폴더 내부 파일들")
        for file in files {
            print("-\(file.name)")
        }
    }
}

let painKiller = Music(name: "Pain Killer", artist: "HarryStyles")
let rebelRebel = Music(name: "Rebel Rebel", artist: "David Bowie")
let thatsLife = Music(name: "That's Life", artist: "Frank Sinatra")

let object = eBook(name: "Object", author: "조영호")
let cleanCode = eBook(name: "Clean Code", author: "Robert. C Martin")
let cleanArchitecture = eBook(name: "Clean Architecture", author: "Robert. C Martin")

var documents = Folder(name: "Documents")
var eBookFolder = Folder(name: "My Book")
var musicFolder = Folder(name: "My Music")

documents.addFile(musicFolder)
documents.addFile(eBookFolder)

musicFolder.addFile(painKiller)
musicFolder.addFile(rebelRebel)
musicFolder.addFile(thatsLife)

eBookFolder.addFile(object)
eBookFolder.addFile(cleanCode)
eBookFolder.addFile(cleanArchitecture)

painKiller.open()
object.open()
print("")

documents.open()
print("")

musicFolder.open()
print("")






