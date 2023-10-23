//
//  View+NumberFormatter.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI

public extension View {

    func numberFormat(for number: Double) -> String {
        Formatter.number.string(for: number) ?? ""
    }
}

extension Formatter {

    static let number: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.groupingSeparator = ","
        numberFormatter.decimalSeparator = "."
        return numberFormatter
    }()
}
