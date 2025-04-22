//
//  AddCardViewModel.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import Foundation

class AddCardViewModel {
    
    // MARK: PickerView components
    
    var onSelectionChanged: ((String) -> Void)?
    
    enum PickerType {
        case month
        case year
    }
    
    private(set) var currentData: [String] = []
    
    private(set) var selectedValue: String?
    
    func updatePickerData(for type: PickerType) {
        switch type {
        case .month:
            currentData = (1...12).map { String(format: "%02d", $0) }
        case .year:
            let currentYear = Calendar.current.component(.year, from: Date())
            currentData = (3...30).map { String(currentYear + $0) }
        }
        selectedValue = currentData.first
    }
    
    func numberOfRows() -> Int {
        return currentData.count
    }

    func title(for row: Int) -> String {
        return currentData[row]
    }

    func didSelectRow(_ row: Int) {
        selectedValue = currentData[row]
        onSelectionChanged?(selectedValue!)
    }
    
    // MARK: Card Validation Components
    
    enum TextFieldType {
        case cardName
        case nameOnCard
        case cardNumber
        case month
        case year
        case cvv
    }
    
    func validateField(type: TextFieldType, value: String?) -> Bool {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return false
        }

        switch type {
        case .cardName, .nameOnCard:
            return !value.isEmpty

        case .cardNumber:
            let cleaned = value.replacingOccurrences(of: " ", with: "")
            return cleaned.count >= 15 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: cleaned))

        case .month:
            if let monthInt = Int(value) {
                return (1...12).contains(monthInt)
            }
            return false

        case .year:
            if let yearInt = Int(value) {
                let currentYear = Calendar.current.component(.year, from: Date()) % 100
                return yearInt >= currentYear
            }
            return false

        case .cvv:
            return value.count == 3 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: value))
        }
    }

    func validateAllFields(_ fields: [(TextFieldType, String?)]) -> (Bool, TextFieldType?) {
        for (type, value) in fields {
            if !validateField(type: type, value: value) {
                return (false, type)
            }
        }
        return (true, nil)
    }
    
    func errorMessage(for type: TextFieldType) -> String {
        switch type {
        case .cardName: return "Please enter a card name"
        case .nameOnCard: return "Please enter the name on card"
        case .cardNumber: return "Please enter a valid 16-digit card number"
        case .month: return "Please enter a valid month (1–12)"
        case .year: return "Please enter a valid year"
        case .cvv: return "Please enter a valid 3-digit CVV"
        }
    }
    
    func formatedCardNumber(_ text: String) -> String {
        let text = text.replacingOccurrences(of: " ", with: "")
        let groups = stride(from: 0, to: text.count, by: 4).map {
            let start = text.index(text.startIndex, offsetBy: $0)
            let end = text.index(start, offsetBy: min(4, text.count - $0))
            return String(text[start..<end])
        }
        return groups.joined(separator: " ")
    }
    
    func detectCardBrandRegex(cardNumber: String) -> Card.CardType {
        let trimmedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        
        guard !trimmedCardNumber.isEmpty else {
            return .unknown
        }
        
        let patterns: [(Card.CardType, String)] = [
            (.visa, "^4\\d{12}(\\d{3})?$"), // 13 or 16 digits, starts with 4
            (.mastercard, "^(5[1-5]\\d{14}|2(2[2-9]\\d{12}|[3-6]\\d{13}|7[01]\\d{12}|720\\d{12}))$"), // 51-55 or 2221-2720
            (.americanExpress, "^3[47]\\d{13}$"), // 34 or 37, 15 digits
            (.discover, "^(6011\\d{12}|65\\d{14}|64[4-9]\\d{13})$"), // 6011, 65, 644-649
            (.jcb, "^35(2[89]|[3-8]\\d)\\d{12}$"), // 3528-3589
            (.unionPay, "^62\\d{14,17}$") // 62, 16-19 digits
        ]
        
        for (brand, pattern) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let range = NSRange(location: 0, length: trimmedCardNumber.utf16.count)
                if regex.firstMatch(in: trimmedCardNumber, options: [], range: range) != nil {
                    return brand
                }
            }
        }
        
        return .unknown
    }

}
