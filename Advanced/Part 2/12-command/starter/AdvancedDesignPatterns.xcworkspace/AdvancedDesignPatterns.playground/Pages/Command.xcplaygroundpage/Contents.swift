/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Command
 - - - - - - - - - -
 ![Command Diagram](Command_Diagram.png)
 
 The command pattern is a behavioral pattern that encapsulates information to perform an action into a "command object." It involves three types:
 
 1. The **invoker** stores and executes commands.
 2. The **command** encapsulates the action as an object.
 3. The **receiver** is the object that's acted upon by the command.
 
 ## Code Example
 */
import Foundation
import Darwin

// MARK: - Example 1
// MARK: - Receiver
public class Door {
    public var isOpen = false
}

// MARK: - Command
public class DoorCommand {
    public let door: Door
    
    public init(_ door: Door) {
        self.door = door
    }
    
    public func execute() {
        
    }
}

public class OpenCommand: DoorCommand {
    public override func execute() {
        print("문을 엽니다")
        door.isOpen = true
    }
}

public class CloseCommand: DoorCommand {
    public override func execute() {
        print("문을 닫습니다")
        door.isOpen = false
    }
}

// MARK: - Invoker
public class Doorman {
    public let commands: [DoorCommand]
    public let door: Door
    
    public init(door: Door) {
        let commandCount = arc4random_uniform(10) + 1
        self.commands = (0..<commandCount).map { index in
            return index % 2 == 0 ?
            OpenCommand(door) : CloseCommand(door)
        }
        self.door = door
    }
    
    public func execute() {
        print("문지기가")
        commands.forEach { $0.execute() }
    }
}

// MARK: - Example
let isOpen = true
print("문이 \(isOpen ? "열려있을거라" : "닫혀있을거라") 예상해봅니다")
print("게임 시작")
print("")

let door = Door()
let doorman = Doorman(door: door)
doorman.execute()
print("")

if door.isOpen == isOpen {
    print("맞췄네요")
} else {
    print("틀렸네요")
}

print("문은 \(door.isOpen ? "열려있습니다" : "닫혀있습니다")")

// MARK: - Example 2
// MARK: - Command
protocol Command {
    var receiver: TextEditor { get set }
    var backup: String { get set }
    
    func execute()
    func undo()
}

// MARK: - Invoker
class Invoker {
    var history: [Command] = []
    
    private func push(command: Command) {
        self.history.append(command)
    }
    
    private func pop() -> Command? {
        return history.popLast()
    }
    
    func executeCommand(command: Command) {
        command.execute()
        self.push(command: command)
    }
    
    func undoCommand() {
        let command = self.pop()
        if command == nil {
            print("되돌릴 작업이 없습니다.")
        } else {
            command?.undo()
        }
    }
}

// MARK: - Receiver
class TextEditor {
    var text: String = ""
    var clipboard: String = ""
}

// MARK: - Concrete Command
class CopyCommand: Command {
    var receiver: TextEditor
    var backup: String = ""
    
    init(receiver: TextEditor) {
        self.receiver = receiver
    }
    
    func undo() {
        receiver.clipboard = self.backup
        self.backup = ""
    }

    func execute() {
        self.backup = receiver.clipboard
        receiver.clipboard = receiver.text
    }
}

// MARK: - Concrete Command
class PasteCommand: Command {
    var receiver: TextEditor
    var backup: String
    
    init(receiver: TextEditor) {
        self.receiver = receiver
        self.backup = self.receiver.clipboard
    }
    
    func undo() {
        let startIndex = receiver.text.startIndex
        let lastIndex = receiver.text.index(startIndex, offsetBy: receiver.text.count - backup.count)
        receiver.text = String(receiver.text[startIndex..<lastIndex])
    }
    
    func execute() {
        self.receiver.text += backup
    }
}

// MARK: - Concrete Command
class WriteCommand: Command {
    var receiver: TextEditor
    var backup: String
    
    init(receiver: TextEditor, backup: String) {
        self.receiver = receiver
        self.backup = backup
    }
   
    func undo() {
        let startIndex = receiver.text.startIndex
        let lastIndex = receiver.text.index(startIndex, offsetBy: receiver.text.count - backup.count)
        receiver.text = String(receiver.text[startIndex..<lastIndex])
    }
    
    func execute() {
        receiver.text += backup
    }
}

let receiver = TextEditor()
let invoker = Invoker()

invoker.executeCommand(command: WriteCommand(receiver: receiver, backup: "가나다"))
print(receiver.text)

invoker.executeCommand(command: CopyCommand(receiver: receiver))
invoker.executeCommand(command: PasteCommand(receiver: receiver))
print(receiver.text)

invoker.executeCommand(command: WriteCommand(receiver: receiver, backup: "라마바"))
print(receiver.text)

invoker.executeCommand(command: PasteCommand(receiver: receiver))
print(receiver.text)

invoker.undoCommand()
print(receiver.text)

invoker.undoCommand()
print(receiver.text)
