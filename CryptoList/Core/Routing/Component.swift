//
//  Component.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

public protocol Component {

    associatedtype Parent
    var parent: Parent { get }
}

extension Never: Component {

    public var parent: Never {
        fatalError("Shouldn't be caller")
    }

    public typealias Parent = Never
}

public extension Component where Parent == Never {

    var parent: Never { fatalError("Shouldn't be caller") }
}
