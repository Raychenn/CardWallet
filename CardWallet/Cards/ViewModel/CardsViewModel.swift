//
//  CardsViewModel.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import Foundation

class CardsViewModel {
    
    private(set) var cards: [Card] = []
    
    var isEmptyState: Bool {
        return cards.isEmpty
    }
    
    func loadMockCards() {
        self.cards = [
            Card(id: "1", cardName: "Card Name", nameOnCard: "Wei Chen", cardNumber: "5153000000001234",
                 expirationMonth: "01", expirationYear: "25", cvv: "123", cardType: .mastercard),
            Card(id: "2", cardName: "Card Name", nameOnCard: "Wei Chen", cardNumber: "4000000000001235",
                 expirationMonth: "02", expirationYear: "26", cvv: "456", cardType: .visa),
            Card(id: "3", cardName: "Card Name", nameOnCard: "Wei Chen", cardNumber: "4000000000001235",
                 expirationMonth: "03", expirationYear: "27", cvv: "789", cardType: .visa)
        ]
    }
    
    func add(_ card: Card) {
        self.cards.append(card)
    }
    
}
