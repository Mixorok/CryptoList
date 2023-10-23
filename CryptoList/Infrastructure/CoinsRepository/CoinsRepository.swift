//
//  CoinsRepository.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Combine

public protocol CoinsRepository {
    var coins: AnyPublisher<[Coin], Never> { get }
    func updateCoins(for currency: String) -> AnyPublisher<Never, Error>
}
