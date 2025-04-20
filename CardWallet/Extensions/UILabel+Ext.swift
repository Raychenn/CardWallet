//
//  UILabel+Ext.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import UIKit

extension UILabel {
    func makeErrorLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
