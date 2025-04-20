import Foundation

struct Card {
    let id: String
    let cardName: String
    let nameOnCard: String
    let cardNumber: String
    let expirationMonth: String
    let expirationYear: String
    let cvv: String
    let cardType: CardType
    
    enum CardType: String {
        case visa = "VISA"
        case mastercard = "Mastercard"
        case americanExpress = "American Express"
        case unionPay = "UnionPay"
        case discover = "Discover"
        case jcb = "JCB"
        case unknown = "Unknown"
    }
    
    var expirationDate: String {
        return "\(expirationMonth)/\(expirationYear)"
    }
    
    var maskedCardNumber: String {
        let last4 = cardNumber.count >= 4 ? String(cardNumber.suffix(4)) : cardNumber
        return "•••• \(last4)"
    }
}
