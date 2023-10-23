//
//  MainViewModel.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Combine
import Foundation

public protocol MainViewModelProtocol: ObservableObject {
    var coins: [Coin] { get }
    var isFetching: Bool { get }
    var viewCoinDetails: Coin? { get }
    func routeToCoinDetails(coin: Coin)
    func cancelRoutingToCoinDetails()
}

public final class MainViewModel: MainViewModelProtocol {

    @Published public var coins: [Coin] = []
    @Published public var isFetching = false
    @Published public var viewCoinDetails: Coin? = nil

    private let routeToDirection: (MainRouting) -> Void

    private var cancellables = Set<AnyCancellable>()

    public init(
        locale: Locale,
        coinsRepository: CoinsRepository,
        routeToDirection: @escaping (MainRouting) -> Void
    ) {
        self.routeToDirection = routeToDirection

        coinsRepository.updateCoins(for: locale.currencyIdentifier)
            .andThen(justReturn: false)
            .prepend(true)
            .sink(receiveValue: { [weak self] in self?.isFetching = $0 })
            .store(in: &cancellables)

        coinsRepository.coins
            .map { $0.sorted(by: { $0.name < $1.name }) }
            .sink(receiveValue: { [weak self] in self?.coins = $0 })
            .store(in: &cancellables)
    }

    public func routeToCoinDetails(coin: Coin) {
        routeToDirection(.coinDetails(coin))
        viewCoinDetails = coin
    }

    public func cancelRoutingToCoinDetails() {
        viewCoinDetails = nil
    }
}

private extension Locale {

    var currencyIdentifier: String {
        currency?.identifier ?? "USD"
    }
}
