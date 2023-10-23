//
//  Coin.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

public struct Coin: Hashable {

    public let currency: String
    public let iconUrl: String?
    public let name: String
    public let symbol: String
    public let price: Double
    public let hourTradeChange: Double?
    public let dayTradeChange: Double?
    public let weekTradeChange: Double?
    public let marketCap: Double
    public let dayVolume: Double
    public let circulatingSupply: Double?
    public let totalSupply: Double?
    public let maxSupply: Double?
    public let dayGraph: [[Double]]
    public let weekGraph: [[Double]]

    public init(
        currency: String,
        iconUrl: String?,
        name: String,
        symbol: String,
        price: Double,
        hourTradeChange: Double?,
        dayTradeChange: Double?,
        weekTradeChange: Double?,
        marketCap: Double,
        dayVolume: Double,
        circulatingSupply: Double?,
        totalSupply: Double?,
        maxSupply: Double?,
        dayGraph: [[Double]],
        weekGraph: [[Double]]
    ) {
        self.currency = currency
        self.iconUrl = iconUrl
        self.name = name
        self.symbol = symbol
        self.price = price
        self.hourTradeChange = hourTradeChange
        self.dayTradeChange = dayTradeChange
        self.weekTradeChange = weekTradeChange
        self.marketCap = marketCap
        self.dayVolume = dayVolume
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.dayGraph = dayGraph
        self.weekGraph = weekGraph
    }
}
