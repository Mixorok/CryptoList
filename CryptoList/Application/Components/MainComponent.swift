//
//  MainComponent.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import SwiftUI

struct MainComponent: Component {

    let coinsRepository: CoinsRepository
    let customAsyncImageRenderer: CustomAsyncImageRenderer

    init() {
        coinsRepository = CoinsRepositoryImpl(
            networkClient: ConfigurableNetworkClient(
                session: .shared,
                requestSerializer: JSONRequestSerializer(),
                responseSerializer: JSONResponseSerializer(),
                endpointConfiguration: APIEndpointConfiguration()
            )
        )
        customAsyncImageRenderer = CustomAsyncImageRendererImpl(
            imageCoordinator: ImageCacheCoordinatorImpl(
                getImageData: ImageLoaderRepositoryImpl(
                    urlSession: .init(configuration: .ephemeral)
                )
            )
        )
    }

    func makeMain() -> AnyView {
        let router = MainRouter(
            routeToCoinDetails: makeCoinDetails
        )
        let mainViewModel = MainViewModel(
            locale: .current,
            coinsRepository: coinsRepository,
            routeToDirection: router.route
        )
        return MainView(
            viewModel: mainViewModel,
            router: router,
            customAsyncImageRenderer: customAsyncImageRenderer).asAny(
        )
    }

    private func makeCoinDetails(coin: Coin) -> AnyView {
        CoinDetailsComponent(parent: self).makeCoinDetails(for: coin)
    }
}
