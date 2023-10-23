//
//  CoinAdditionalInformationView.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI

struct CoinAdditionalInformationView: View {

    private let coin: Coin

    @State private var availableSpace: Double = 0

    init(coin: Coin) {
        self.coin = coin
    }

    var body: some View {
        VStack(spacing: 16) {
            makeRow(
                for: "Market Cap",
                value: coin.marketCap.toMonetaryString(currency: coin.currency)
            )
            makeRow(
                for: "24 Hour Trading Vol",
                value: coin.dayVolume.toMonetaryString(currency: coin.currency)
            )
            makeRow(
                for: "Circulating Supply",
                value: coin.circulatingSupply?.toMonetaryString(currency: coin.currency) ?? "-"
            )
            makeRow(
                for: "Total Supply",
                value: coin.totalSupply?.toMonetaryString(currency: coin.currency) ?? "-"
            )
            makeRow(
                for: "Max Supply",
                value: coin.maxSupply?.toMonetaryString(currency: coin.currency) ?? "-"
            )
        }
    }

    @ViewBuilder private func makeRow(for title: String, value: String) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(value)
                    .font(.caption)
            }
            Divider()
        }
    }
}
