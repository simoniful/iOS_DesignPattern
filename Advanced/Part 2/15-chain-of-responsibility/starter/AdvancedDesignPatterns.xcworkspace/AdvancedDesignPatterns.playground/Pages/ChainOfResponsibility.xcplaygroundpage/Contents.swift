/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Chain Of Responsibility
 - - - - - - - - - -
 ![Chain Of Responsibility Diagram](ChainOfResponsibility_Diagram.png)
 
The chain of responsibility pattern is a behavioral design pattern that allows an event to be processed by one of many handlers. It involves three types:
 
 1. The **client** accepts and passes events to an instance of a handler protocol.
 
 2. The **handler protocol** defines required properties and methods that concrete handlers must implement.
 
 3. The first **concrete handler** implements the handler protocol and is stored directly by the client. It first attempts to handle the event that's passed to it. If it's not able to do so, it passes the event onto its **next** concrete handler, which it holds as a strong property.
 
 ## Code Example
 */
import Foundation

// MARK: - Example 1
// MARK: - Models
public class Coin {
  public class var standardDiameter: Double { return 0 }
  public class var standardWeight: Double { return 0 }
  public var centValue: Int { return 0 }
  public final var dollarValue: Double {
    return Double(centValue) / 100
  }
  
  public final let diameter: Double
  public final let weight: Double
  
  public required init(diameter: Double, weight: Double) {
    self.diameter = diameter
    self.weight = weight
  }
  
  public convenience init() {
    let diameter = type(of: self).standardDiameter
    let weight = type(of: self).standardWeight
    self.init(diameter: diameter, weight: weight)
  }
}

extension Coin: CustomStringConvertible {
  public var description: String {
    return String(format: "%@ { diameter: %0.3f, dollarValue: $0.2f, weight: %0.3f }",
                  "\(type(of: self))", diameter, dollarValue, weight)
  }
}

public class Penny: Coin {
  public override class var standardDiameter: Double { return 19.05 }
  public override class var standardWeight: Double { return 2.5 }
  public override var centValue: Int { return 1 }
}

public class Nickel: Coin {
  public override class var standardDiameter: Double { return 21.21 }
  public override class var standardWeight: Double { return 5.0 }
  public override var centValue: Int { return 5 }
}

public class Dime: Coin {
  public override class var standardDiameter: Double { return 17.91 }
  public override class var standardWeight: Double { return 2.268 }
  public override var centValue: Int { return 10 }
}

public class Quarter: Coin {
  public override class var standardDiameter: Double { return 24.26 }
  public override class var standardWeight: Double { return 5.670 }
  public override var centValue: Int { return 25 }
}


// MARK: - HandlerProtocol
public protocol CoinHandlerProtocol {
    var next: CoinHandlerProtocol? { get }
    
    func handlerCoinValidation(_ unknownCoin: Coin) -> Coin?
}

// MARK: -  Concrete Handler
public class CoinHandler {
    public var next: CoinHandlerProtocol?
    public let coinType: Coin.Type
    public let diameterRange: ClosedRange<Double>
    public let weightRange: ClosedRange<Double>
    
    public init(
        coinType: Coin.Type,
        diameterVariation: Double = 0.05,
        weightVariation: Double = 0.05
    ) {
        self.coinType = coinType
        
        let standardDiameter = coinType.standardDiameter
        self.diameterRange =
            (1 - diameterVariation) * standardDiameter ...
            (1 + diameterVariation) * standardDiameter
        
        let standardWeight = coinType.standardWeight
        self.weightRange =
            (1 - weightVariation) * standardWeight ...
            (1 + weightVariation) * standardWeight
    }
}

extension CoinHandler: CoinHandlerProtocol {
    public func handlerCoinValidation(_ unknownCoin: Coin) -> Coin? {
        guard let coin = createCoin(unknownCoin) else {
            return next?.handlerCoinValidation(unknownCoin)
        }
        return coin
    }
    
    private func createCoin(_ unknownCoin: Coin) -> Coin? {
        print("\(coinType) 만들기를 시도합니다")
        guard diameterRange.contains(unknownCoin.diameter) else {
            print("유효하지 않은 직경입니다")
            return nil
        }
        guard weightRange.contains(unknownCoin.weight) else {
            print("유효하지 않은 무게입니다")
            return nil
        }
        let coin = coinType.init(
            diameter: unknownCoin.diameter,
            weight: unknownCoin.weight
        )
        print("\(coin) 제작 완료")
        return coin
    }
}

// MARK: - Client
public class VendingMachine {
    public let coinHandler: CoinHandler
    public var coins: [Coin] = []
    
    public init(coinHandler: CoinHandler) {
        self.coinHandler = coinHandler
    }
    
    public func insertCoin(_ unknownCoin: Coin) {
        guard let coin = coinHandler.handlerCoinValidation(unknownCoin) else {
            print("규격에 맞지 않아 \(unknownCoin)이 반환됩니다")
            return
        }
        print("규격에 맞기에 \(coin)이 들어갔습니다")
        coins.append(coin)
        
        let dollarValue = coins.reduce(0) {
            $0 + $1.dollarValue
        }
        print("")
        print("들어간 모든 동전의 달러 가치는 \(dollarValue)입니다")
        
        let weight = coins.reduce(0) {
            $0 + $1.weight
        }
        print("들어간 모든 동전의 총 무게는 \(weight)g 입니다")
        print("")
    }
}

// MARK: - Example
let pennyHandler = CoinHandler(coinType: Penny.self)
let nickelHandler = CoinHandler(coinType: Nickel.self)
let dimeHandler = CoinHandler(coinType: Dime.self)
let quarterHandler = CoinHandler(coinType: Quarter.self)

pennyHandler.next = nickelHandler
nickelHandler.next = dimeHandler
dimeHandler.next = quarterHandler

let vendingMachine = VendingMachine(coinHandler: pennyHandler)

let penny = Penny()
vendingMachine.insertCoin(penny)

let quarter = Coin(
    diameter: Quarter.standardDiameter,
    weight: Quarter.standardWeight
)
vendingMachine.insertCoin(quarter)

let invalidDime = Coin(
    diameter: Quarter.standardDiameter,
    weight: Dime.standardWeight
)
vendingMachine.insertCoin(invalidDime)

// MARK: - Example 2
// MARK: - HandlerProtocol
protocol CustomerServiceHandler: AnyObject {
    var nextHandler: CustomerServiceHandler? { get set }
    func setNext(handler: CustomerServiceHandler)
    func handle(request: String) -> String
}

extension CustomerServiceHandler {
    func setNext(handler: CustomerServiceHandler) {
        if self.nextHandler == nil {
            self.nextHandler = handler
        } else {
            self.nextHandler?.setNext(handler: handler)
        }
    }
}

// MARK: - Concrete Handler 1
class MainAppleServiceHandler: CustomerServiceHandler {
    var nextHandler: CustomerServiceHandler?
    
    func handle(request: String) -> String {
        if request == "Apple" {
            return "Apple 부서로 연결합니다."
        } else {
            if let response = nextHandler?.handle(request: request) {
                return response
            } else {
                return "원하시는 서비스는 제공하지 않습니다."
            }
        }
    }
}

// MARK: - Concrete Handler 2
class MobileServiceHandler: CustomerServiceHandler {
    var nextHandler: CustomerServiceHandler?
    
    func handle(request: String) -> String {
        if request == "Mobile" {
            return "Mobile 부서로 연결합니다."
        } else {
            if let response = nextHandler?.handle(request: request) {
                return response
            } else {
                return "원하시는 서비스는 제공하지 않습니다."
            }
        }
    }
}

// MARK: - Concrete Handler 3
class IPhoneServiceHandler: CustomerServiceHandler {
    var nextHandler: CustomerServiceHandler?
    
    func handle(request: String) -> String {
        if request == "iPhone" {
            return "iPhone 부서로 연결합니다."
        } else {
            if let response = nextHandler?.handle(request: request) {
                return response
            } else {
                return "원하시는 서비스는 제공하지 않습니다."
            }
        }
    }
}

// MARK: - Client
class Client {
    private var firstHandler: CustomerServiceHandler?
    
    func request(request: String) -> String {
        return self.firstHandler?.handle(request: request) ?? "firstHandler를 설정해주세요"
    }
    func addHandler(handler: CustomerServiceHandler) {
        if let firstHandler = firstHandler {
            firstHandler.setNext(handler: handler)
        } else {
            self.firstHandler = handler
        }
    }
}

let client = Client()

let appleService = MainAppleServiceHandler()
let mobileService = MobileServiceHandler()
let iphoneService = IPhoneServiceHandler()

client.addHandler(handler: appleService)
client.addHandler(handler: mobileService)
client.addHandler(handler: iphoneService)

print("")
print(client.request(request: "Apple"))
print(client.request(request: "iPhone"))
print(client.request(request: "iPad"))
