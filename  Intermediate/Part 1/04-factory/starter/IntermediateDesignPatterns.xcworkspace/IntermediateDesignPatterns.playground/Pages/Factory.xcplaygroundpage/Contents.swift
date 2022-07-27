/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Factory
 - - - - - - - - - -
 ![Factory Diagram](Factory_Diagram.png)
 
 The factory pattern provides a way to create objects without exposing creation logic. It involves two types:
 
 1. The **factory** creates objects.
 2. The **products** are the objects that are created.
 
 ## Code Example
 */

import Foundation

// MARK: - Example 1

// MARK: - Model
public struct JobApplicant {
    public enum Status {
        case new
        case interview
        case hired
        case rejected
    }
    
    public let name: String
    public let email: String
    public var status: Status
}

public struct Email {
    public let subject: String
    public let messageBody: String
    public let recipientEmail: String
    public let senderEmail: String
}

// MARK: - Factory
public struct EmailFactory {
    public let senderEmail: String
    
    public func createEmail(to recipient: JobApplicant) -> Email {
        let subject: String
        let messageBody: String
        switch recipient.status {
        case .new:
            subject = "We Received Your Application"
            messageBody = "Thanks for applying for a job here! " +
            "You should hear from us in 17-42 business days."
            
        case .interview:
            subject = "We Want to Interview You"
            messageBody = "Thanks for your resume, \(recipient.name)! " +
            "Can you come in for an interview in 30 minutes?"
            
        case .hired:
            subject = "We Want to Hire You"
            messageBody = "Congratulations, \(recipient.name)! " +
            "We liked your code, and you smelled nice. " +
            "We want to offer you a position! Cha-ching! $$$"
            
        case .rejected:
            subject = "Thanks for Your Application"
            messageBody = "Thank you for applying, \(recipient.name)! " +
            "We have decided to move forward with other candidates. " +
            "Please remember to wear pants next time!"
        }
        
        return Email(
            subject: subject,
            messageBody: messageBody,
            recipientEmail: recipient.email,
            senderEmail: senderEmail
        )
    }
}

var jack = JobApplicant(
    name: "Jack Ryan",
    email: "jack.ryan@apple.com",
    status: .new
)

let emailFactory = EmailFactory(
    senderEmail: "simon@apple.com"
)

print(emailFactory.createEmail(to: jack), "\n")

jack.status = .hired

print(emailFactory.createEmail(to: jack), "\n")

// MARK: - Example 2

// Product Interface
protocol Player {
    var content: String { get set }
    init(content: String)
    func play()
    func pause()
    func changeContent(name: String)
}

// Concrete Product
class MusicPlayer: Player {
    var content: String
    required init(content: String) {
        self.content = content
    }
    
    func play() {
        print("MusicPlayer Play")
    }
    
    func pause() {
        print("MusicPlayer Pause")
    }
    
    func changeContent(name: String) {
        print("\(self.content)에서 \(name)로 음악 변경")
        self.content = name
    }
}

// Concrete Product
class VideoPlayer: Player {
    var content: String
    required init(content: String) {
        self.content = content
    }
    
    func play() {
        print("VideoPlayer Play")
    }
    
    func pause() {
        print("VideoPlayer Pause")
    }
    
    func changeContent(name: String) {
        print("\(self.content)에서 \(name)로 비디오 변경")
        self.content = name
    }
}

// Creator
protocol PlayerCreator {
    func createPlayer(content: String, contentType: ContentType) -> Player
}

enum ContentType {
    case music
    case video
}

// Factory (Concrete Creator)
class PlayerFactory: PlayerCreator {
    func createPlayer(content: String, contentType: ContentType) -> Player {
        switch contentType {
        case .music:
            return MusicPlayer(content: content)
        case .video:
            return VideoPlayer(content: content)
        }
    }
}

let factory = PlayerFactory()
let musicPlayer = factory.createPlayer(content: "Jazz", contentType: .music)
let videoPlayer = factory.createPlayer(content: "Action", contentType: .video)

musicPlayer.play()
musicPlayer.changeContent(name: "Classic")

videoPlayer.play()
videoPlayer.changeContent(name: "Romance")


// MARK: - Example 3

// Product Interface
protocol Animal {
    var name: String { get set }
    func sound()
}

// Concrete Product
class Dog: Animal {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func sound() {
        print("\(name) Bark! 🐶")
    }
}

// Concrete Product
class Cat: Animal {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func sound() {
        print("\(name) Meow! 😸")
    }
}

// Creator
protocol AnimalFactory {
    func make(with name: String) -> Animal
}
 
// Factory (Concrete Creator)
class RandomAnimalFactory: AnimalFactory {
    func make(with name: String) -> Animal {
        return Int.random(in: 0...1) == 0 ? Dog(name: name) : Cat(name: name)
    }
}

// Factory (Concrete Creator)
class EvenAnimalFactory: AnimalFactory {
    var previousState: Animal.Type?
    func make(with name: String) -> Animal {
        if previousState == Cat.self {
            self.previousState = Dog.self
            return Dog(name: name)
        } else {
            self.previousState = Cat.self
            return Cat(name: name)
        }
    }
}

class AnimalCafe {
    private var animals = [Animal]()
    private var factory: AnimalFactory
    
    init(factory: AnimalFactory) {
        self.factory = factory
    }
    
    func addAnimal(with name: String) {
        self.animals.append(self.factory.make(with: name))
    }
    
    func printAnimals() {
        self.animals.forEach { animal in
            animal.sound()
        }
    }
    
    func change(factory: AnimalFactory) {
        self.factory = factory
    }
    
    func clear() {
        self.animals = []
    }
}

let animalCafe = AnimalCafe(factory: EvenAnimalFactory())
animalCafe.addAnimal(with: "A")
animalCafe.addAnimal(with: "B")
animalCafe.addAnimal(with: "C")
animalCafe.addAnimal(with: "D")
animalCafe.addAnimal(with: "E")
animalCafe.addAnimal(with: "F")
animalCafe.printAnimals()
 
animalCafe.clear()
print("\n## Change Factory ##\n")
animalCafe.change(factory: RandomAnimalFactory())
animalCafe.addAnimal(with: "A")
animalCafe.addAnimal(with: "B")
animalCafe.addAnimal(with: "C")
animalCafe.addAnimal(with: "D")
animalCafe.addAnimal(with: "E")
animalCafe.addAnimal(with: "F")
animalCafe.printAnimals()

