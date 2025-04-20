//
//  UITextField+Ext.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import UIKit

extension UITextField {
    static func defaultTextField(
        placeholder: String,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .next
    ) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = isSecure
        field.keyboardType = keyboardType
        field.returnKeyType = returnKeyType
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }
    
    func highlightError(_ show: Bool) {
        if show {
            self.layer.borderColor = UIColor.systemRed.cgColor
            self.layer.borderWidth = 1
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
        }
    }
}
