//
//  CoinDetailsViewModel.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import Combine

public protocol CoinDetailsViewModelProtocol: ObservableObject {
    var coin: Coin { get }
}

public final class CoinDetailsViewModel: CoinDetailsViewModelProtocol {

    @Published public var coin: Coin

    public init(coin: Coin) {
        self.coin = coin
    }

    
}
