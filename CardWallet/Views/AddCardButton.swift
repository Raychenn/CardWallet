//
//  StateButton.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import UIKit

class AddCardButton: UIButton {
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
            } else {
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
            }
        }
    }
}
