//
//  String+Ext.swift
//  CardWallet
//
//  Created by Boray Chen on 2025/4/20.
//

import Foundation

extension String {
    var groupedEvery4Digits: String {
        self.enumerated().map { index, char in
            return index % 4 == 0 && index != 0 ? " \(char)" : "\(char)"
        }.joined()
    }
}
