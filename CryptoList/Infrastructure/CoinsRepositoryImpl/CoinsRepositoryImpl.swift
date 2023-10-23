//
//  CoinsRepositoryImpl.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Combine

public final class CoinsRepositoryImpl: CoinsRepository {

    private static let cacheKey = "coins"
    private static let maxCoins = 15

    public var coins: AnyPublisher<[Coin], Never> {
        _coins.eraseToAnyPublisher()
    }

    private let _coins = CurrentValueSubject<[Coin], Never>([])

    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func updateCoins(for currency: String) -> AnyPublisher<Never, Error> {
        fetchCoinsList()
            .flatMap { coins in
                coins
                    .map(\.id)
                    .publisher
                    .flatMap{ self.fetchCoinDetails(for: $0, with: currency) }
                    .compactMap { $0 }
                    .collect()
            }
            .handleEvents(receiveOutput: { self._coins.send($0)} )
            .ignoreOutput()
            .eraseToAnyPublisher()
    }

    private func fetchCoinsList() -> AnyPublisher<[ModestCoin], Error> {
        networkClient.get(
            [ModestCoin].self,
            path: "coins/list"
        )
        .map { Array($0[..<Self.maxCoins]) }
        .eraseToAnyPublisher()
    }

    private func fetchCoinDetails(
        for id: String,
        with currency: String
    ) -> AnyPublisher<Coin?, Never> {
        Publishers.CombineLatest3(
            fetchCoin(for: id, with: currency),
            fetchCoinChart(for: id, days: "1", currency: currency),
            fetchCoinChart(for: id, days: "7", currency: currency)
        )
        .map { Coin(response: $0, dayGraph: $1, weekGraph: $2, currency: currency) }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }

    private func fetchCoin(
        for id: String,
        with currency: String
    ) -> AnyPublisher<CoinEntity, Error> {
        networkClient.get(
            CoinEntity.self,
            path: "coins/\(id)"
        )
    }

    private func fetchCoinChart(
        for id: String,
        days: String,
        currency: String
    ) -> AnyPublisher<[[Double]], Error> {
        networkClient.get(
            CoinChart.self,
            path: "coins/\(id)/market_chart",
            queryItems: [
                .init(name: "vs_currency", value: currency),
                .init(name: "days", value: days)
            ]
        )
        .map(\.prices)
        .eraseToAnyPublisher()
    }
}

private struct ModestCoin: Codable {
    let id: String
}

private struct CoinEntity: Decodable {
    let image: ImageEntity?
    let name: String
    let symbol: String
    let market_data: MarketDataEntity
}

private struct CoinChart: Decodable {
    let prices: [[Double]]
}

private struct MarketDataEntity: Decodable {
    let current_price: [String: Double]
    let price_change_percentage_1h_in_currency: [String: Double?]
    let price_change_percentage_24h_in_currency: [String: Double?]
    let price_change_percentage_7d_in_currency: [String: Double?]
    let market_cap: [String: Double]
    let total_volume: [String: Double]
    let circulating_supply: Double?
    let total_supply: Double?
    let max_supply: Double?
}

private struct ImageEntity: Decodable {
    let small: String
}

private extension Coin {

    init?(response: CoinEntity, dayGraph: [[Double]], weekGraph: [[Double]], currency: String) {
        let currentCurrency: String
        if response.market_data.current_price[currency] != nil {
            currentCurrency = currency
        } else {
            currentCurrency = "usd"
        }
        guard
            let price = response.market_data.current_price[currentCurrency],
            let market_cap = response.market_data.market_cap[currentCurrency],
            let total_volume = response.market_data.total_volume[currentCurrency]
        else {
            return nil
        }
        let market_data = response.market_data
        self = .init(
            currency: currentCurrency,
            iconUrl: response.image?.small,
            name: response.name,
            symbol: response.symbol,
            price: price,
            hourTradeChange: market_data.price_change_percentage_1h_in_currency[currentCurrency]
                ?? nil,
            dayTradeChange: market_data.price_change_percentage_24h_in_currency[currentCurrency]
                ?? nil,
            weekTradeChange: market_data.price_change_percentage_7d_in_currency[currentCurrency]
                ?? nil,
            marketCap: market_cap,
            dayVolume: total_volume,
            circulatingSupply: market_data.circulating_supply,
            totalSupply: market_data.total_supply,
            maxSupply: market_data.max_supply,
            dayGraph: dayGraph,
            weekGraph: weekGraph
        )
    }
}
