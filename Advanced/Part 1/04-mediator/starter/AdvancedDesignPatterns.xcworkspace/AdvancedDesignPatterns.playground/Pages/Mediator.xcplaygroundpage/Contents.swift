/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Mediator
 - - - - - - - - - -
 ![Mediator Diagram](Mediator_Diagram.png)
 
 The mediator pattern is a behavioral design pattern that encapsulates how objects communicate with one another. It involves four types:
 
 1. The **colleagues** are the objects that want to communicate with each other. They implement the colleague protocol.
 
 2. The **colleague protocol** defines methods and properties that each colleague must implement.
 
 3. The **mediator** is the object that controls the communication of the colleagues. It implements the mediator protocol.
 
 4. The **mediator protocol** defines methods and properties that the mediator must implement.
 
 ## Code Example
 */
import Foundation

// MARK: - Example 1

// MARK: - Colleague Protocol
public protocol Colleague: AnyObject {
    func colleague(_ colleague: Colleague?, didReceive message: String)
}

// MARK: - Mediator Protocol
public protocol MediatorProtocol: AnyObject {
    func addColleague(_ colleague: Colleague)
    func sendMessage(_ message: String, by colleague: Colleague)
}

// MARK: - Colleague
public class Musketeer {
    public var name: String
    public weak var mediator: MediatorProtocol?
    
    public init(name: String, mediator: MediatorProtocol) {
        self.name = name
        self.mediator = mediator
        mediator.addColleague(self)
    }
    
    public func sendMessage(_ message: String) {
        print("\(name) sent: \(message)")
        mediator?.sendMessage(message, by: self)
    }
}

extension Musketeer: Colleague {
    public func colleague(_ colleague: Colleague?, didReceive message: String) {
        print("\(name) received: \(message)")
    }
}

// MARK: - Mediator
public class MusketeerMediator: Mediator<Colleague> {
    
}

extension MusketeerMediator: MediatorProtocol {
    public func addColleague(_ colleague: Colleague) {
        addColleague(colleague, strongReference: true)
    }
    
    public func sendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didReceive: message)
        }
    }
}

// MARK: - Example
let mediator = MusketeerMediator()
let athos = Musketeer(name: "Athos", mediator: mediator)
let porthos = Musketeer(name: "Porthos", mediator: mediator)
let aramis = Musketeer(name: "Aramis", mediator: mediator)

athos.sendMessage("One for all...")
print("")
porthos.sendMessage("and all for one...")
print("")
aramis.sendMessage("Unos pro omnibus, omnes pro uno!")
print("")

mediator.invokeColleagues() {
  $0.colleague(nil, didReceive: "Charge!")
}

// MARK: - Example 2

// Mediator
protocol _Mediator {
    func notify(sender: _Colleague, event: EventType)
}

enum EventType {
    case checkBoxSelect
    case checkBoxUnselect
}

// Base Colleague
class _Colleague {
    var mediator: _Mediator?
    
    func setMediator(mediator: _Mediator) {
        self.mediator = mediator
    }
}

// Collegue
class CheckBox: _Colleague {
    var isSelect: Bool = false {
        didSet {
            if isSelect {
                print("CheckBox 선택")
            } else {
                print("CheckBox 선택 해제")
            }
        }
    }
    
    func checkBoxClick() {
        self.isSelect = !self.isSelect
        if self.isSelect {
            self.mediator?.notify(sender: self, event: .checkBoxSelect)
        } else {
            self.mediator?.notify(sender: self, event: .checkBoxUnselect)
        }
    }
}

// Collegue
class TextField: _Colleague {
    var isHidden: Bool = true {
        didSet {
            if isHidden {
                print("TextField 비활성화")
            } else {
                print("TextField 활성화")
            }
        }
    }
}

// Concrete Mediator
class ProfileUI: _Mediator {
    var checkBox: CheckBox
    var textField: TextField
    
    init(checkBox: CheckBox, textField: TextField) {
        self.checkBox = checkBox
        self.textField = textField
        
        self.checkBox.setMediator(mediator: self)
        self.textField.setMediator(mediator: self)
    }
    
    func notify(sender: _Colleague, event: EventType) {
        switch event {
        case .checkBoxSelect:
            self.textField.isHidden = false
        case .checkBoxUnselect:
            self.textField.isHidden = true
        }
    }
}

let checkBox = CheckBox()
let textField = TextField()
let profileUI = ProfileUI(
    checkBox: checkBox,
    textField: textField
)

print("")
profileUI.checkBox.checkBoxClick()
profileUI.checkBox.checkBoxClick()




