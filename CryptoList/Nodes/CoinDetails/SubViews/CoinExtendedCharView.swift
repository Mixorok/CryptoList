//
//  CoinExtendedCharView.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI
import Charts

struct CoinExtendedCharView: View {

    private let coin: Coin

    init(coin: Coin) {
        self.coin = coin
    }

    var body: some View {
        Chart {
            ForEach(coin.dayGraph, id: \.self) { item in
                LineMark(
                    x: .value("Date", Date(timeIntervalSince1970: item[0]/1000)),
                    y: .value("Value", item[1])
                )
                .foregroundStyle(Color.green)
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
    }
}
