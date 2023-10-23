//
//  MainView.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import SwiftUI

public struct MainView<ViewModel: MainViewModelProtocol>: View {

    @ObservedObject private var viewModel: ViewModel
    @ObservedObject private var router: BaseRouter<MainRouting>
    private let customAsyncImageRenderer: CustomAsyncImageRenderer

    public init(
        viewModel: ViewModel,
        router: BaseRouter<MainRouting>,
        customAsyncImageRenderer: CustomAsyncImageRenderer
    ) {
        self.viewModel = viewModel
        self.router = router
        self.customAsyncImageRenderer = customAsyncImageRenderer
    }

    public var body: some View {
        NavigationStack {
            if viewModel.isFetching {
                ProgressView()
            } else {
                ScrollView(.vertical) {
                    ScrollView(.horizontal) {
                        CoinListView(
                            coins: viewModel.coins,
                            rowAction: { viewModel.routeToCoinDetails(coin: $0) },
                            customAsyncImageRenderer: customAsyncImageRenderer
                        )
                        .frame(maxHeight: .infinity)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .navigationDestination(
                    item: Binding(
                        get: { viewModel.viewCoinDetails },
                        set: { _ in viewModel.cancelRoutingToCoinDetails() }
                    ),
                    destination: { 
                        router.view(for: .coinDetails($0))
                            .navigationTitle($0.name)
                    }
                )

            }
        }
    }
}
