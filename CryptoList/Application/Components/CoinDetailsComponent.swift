//
//  CoinDetailsComponent.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI

struct CoinDetailsComponent: Component {

    var parent: MainComponent

    func makeCoinDetails(for coin: Coin) -> AnyView {
        CoinDetailsView(
            viewModel: CoinDetailsViewModel(coin: coin),
            customAsyncImageRenderer: parent.customAsyncImageRenderer
        ).asAny()
    }
}
