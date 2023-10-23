//
//  CoinListView.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI

struct CoinListView: View {

    private let coins: [Coin]
    private let rowAction: (Coin) -> Void
    private let customAsyncImageRenderer: CustomAsyncImageRenderer

    init(
        coins: [Coin],
        rowAction: @escaping (Coin) -> Void,
        customAsyncImageRenderer: CustomAsyncImageRenderer
    ) {
        self.coins = coins
        self.rowAction = rowAction
        self.customAsyncImageRenderer = customAsyncImageRenderer
    }

    var body: some View {
        Grid(alignment: .trailing, horizontalSpacing: 24, verticalSpacing: 24) {
            GridRow {
                Text("Coin")
                    .gridColumnAlignment(.leading)
                Text("Price")
                Text("1h")
                Text("24h")
                Text("7d")
                Text("24h Volume")
                Text("Mkt Cap")
                Text("Last 7 Days")
            }
            .font(.headline)
            Divider()
            ForEach(coins, id: \.name) { coin in
                GridRow {
                    coinName(for: coin)
                    numberFormat(for: coin.price, currency: coin.currency)
                    tradeChange(for: coin.hourTradeChange)
                    tradeChange(for: coin.dayTradeChange)
                    tradeChange(for: coin.weekTradeChange)
                    numberFormat(for: coin.dayVolume, currency: coin.currency)
                    numberFormat(for: coin.marketCap, currency: coin.currency)
                    CoinChartView(coin: coin)
                        .frame(height: 24)
                }
                .onTapGesture {
                    rowAction(coin)
                }
                Divider()
            }
        }
    }

    @ViewBuilder private func coinName(for coin: Coin) -> some View {
        HStack {
            customAsyncImageRenderer.renderImage(
                by: coin.name,
                for: URL(string: coin.iconUrl ?? ""),
                content: { $0.resizable() },
                placeholder: { Image(systemName: "face.dashed") }
            )
            .frame(width: 25, height: 25)

            Text(coin.name)
                .font(.headline)

            Text(coin.symbol.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder private func tradeChange(for percent: Double?) -> some View {
        if let percent {
            if percent > 0 {
                Text("\(percent, specifier: "%.2f")%")
                    .foregroundColor(.green)
            } else {
                Text("\(percent, specifier: "%.2f")%")
                    .foregroundColor(.red)
            }
        } else {
            Text("-")
        }
    }

    @ViewBuilder private func numberFormat(for number: Double, currency: String) -> some View {
        Text("\(currency.uppercased()) ") + Text(numberFormat(for: number))
    }
}
