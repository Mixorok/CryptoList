//
//  BaseRouter.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import SwiftUI

open class BaseRouter<Direction: Hashable>: ObservableObject {

    public typealias RoutingToken = Int

    @Published public private(set) var routers: [RoutingToken: AnyView] = [:]

    public init() {}

    open func route(to direction: Direction) {
        fatalError("Not implemented")
    }

    public func back(from direction: Direction) {
        routers[direction.hashValue] = nil
    }

    public func view(for direction: Direction) -> AnyView {
        routers[direction.hashValue] ?? AnyView(EmptyView())
    }

    @discardableResult
    public func set(
        view: AnyView,
        for direction: Direction
    ) -> RoutingToken {
        let routingToken = direction.hashValue

        if !routers.keys.contains(routingToken) {
            routers[routingToken] = view
        }
        return routingToken
    }
}
