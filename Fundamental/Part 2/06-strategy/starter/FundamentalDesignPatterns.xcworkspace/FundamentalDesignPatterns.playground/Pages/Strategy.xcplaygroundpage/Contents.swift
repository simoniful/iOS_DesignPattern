/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Strategy
 - - - - - - - - - -
 ![Strategy Diagram](Strategy_Diagram.png)
 
 The strategy pattern defines a family of interchangeable objects.
 
 This pattern makes apps more flexible and adaptable to changes at runtime, instead of requiring compile-time changes.
 
 ## Code Example
 */

import UIKit

public protocol MovieRatingStrategy {
    var ratingServiceName: String { get }
    
    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> ()
    )
}

public class RottenTomatoesClient: MovieRatingStrategy {
    public let ratingServiceName = "Rotten Tomatoes"
    
    public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
        let rating = "95%"
        let review = "It rocked!"
        success(rating, review)
    }
}

public class IMDbClient: MovieRatingStrategy {
    public let ratingServiceName = "IMDb"
    
    public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
        let rating = "3/10"
        let review = "It sucks! The audience was throwing rotten tomatoes!"
        success(rating, review)
    }
}

public class MovieRatingViewController: UIViewController {
    // MARK: - Properties
    
    public var moviewRatingClient: MovieRatingStrategy!
    
    // MARK: - Outlets
    @IBOutlet public var movieTitleTextField: UITextField!
    @IBOutlet public var ratingServiceNameLabel: UILabel!
    @IBOutlet public var ratingLabel: UILabel!
    @IBOutlet public var reviewLabel: UILabel!
    
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        ratingServiceNameLabel.text = moviewRatingClient.ratingServiceName
    }
    
    // MARK: - Actions
    @IBAction public func searchButtonPressed(_ sender: Any) {
        guard let movieTitle = movieTitleTextField.text, movieTitle.count > 0 else { return }
        moviewRatingClient.fetchRating(for: movieTitle) { rating, review in
            self.ratingLabel.text = rating
            self.reviewLabel.text = review
        }
    }
}

protocol Validatable {
    func validate(text: String) -> Bool
}
 
protocol Validator {
    var validationStrategy: Validatable { get set }
    func validate(text: String) -> Bool
}

final class StringValidator: Validator {
    var validationStrategy: Validatable
    
    init(strategy: Validatable) {
        self.validationStrategy = strategy
    }
    
    func change(strategy: Validatable) {
        self.validationStrategy = strategy
    }
    
    func validate(text: String) -> Bool {
        return validationStrategy.validate(text: text)
    }
    
    func validateAll(text: String) -> Bool {
        let strategies: [Validatable] = [LengthValidator(), NumberValidator(), AsciiValidator()]
        return strategies.filter({ strategy in
            return StringValidator(strategy: strategy).validate(text: text)
        }).isEmpty
    }
}

class NumberValidator: Validatable {
    func validate(text: String) -> Bool {
        return text.allSatisfy({ $0.isNumber })
    }
}
 
class LengthValidator: Validatable {
    func validate(text: String) -> Bool {
        return text.count < 10
    }
}

class AsciiValidator: Validatable {
    func validate(text: String) -> Bool {
        return text.allSatisfy({ $0.isASCII })
    }
}

let validator = StringValidator(strategy: LengthValidator())
print(validator.validate(text: "12345678910"))
 
validator.change(strategy: NumberValidator())
print(validator.validate(text: "12345678910"))

validator.change(strategy: AsciiValidator())
print(validator.validate(text: "12345678910"))

print(validator.validateAll(text: "12345678910"))
