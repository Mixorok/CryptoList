//
//  MainRouter.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import SwiftUI

public enum MainRouting: Hashable {
    case coinDetails(Coin)
}

public final class MainRouter: BaseRouter<MainRouting> {

    private let routeToCoinDetails: (Coin) -> AnyView

    public init(routeToCoinDetails: @escaping (Coin) -> AnyView) {
        self.routeToCoinDetails = routeToCoinDetails
        super.init()
    }

    public override func route(to direction: MainRouting) {
        switch direction {
        case .coinDetails(let coin):
            set(view: routeToCoinDetails(coin), for: direction)
        }
    }
}
