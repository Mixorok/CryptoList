//
//  MonteryAmount.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import Foundation

public extension Double {

    func toMonetaryString(currency: String) -> String {
        return currency.uppercased() + " " + (Formatter.number.string(for: self) ?? "")
    }
}
