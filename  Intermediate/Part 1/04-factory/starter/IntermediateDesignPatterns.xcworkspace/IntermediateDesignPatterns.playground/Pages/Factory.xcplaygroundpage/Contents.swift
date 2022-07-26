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

// MARK: - Example
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


