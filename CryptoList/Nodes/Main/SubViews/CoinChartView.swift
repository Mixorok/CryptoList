//
//  CoinChartView.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI
import Charts

struct CoinChartView: View {

    let coin: Coin

    var body: some View {
        Chart {
            ForEach(coin.weekGraph, id: \.self) { item in
                LineMark(
                    x: .value("Date", Date(timeIntervalSince1970: item[0]/1000)),
                    y: .value("Value", item[1])
                )
                .foregroundStyle(Color.green)
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}
