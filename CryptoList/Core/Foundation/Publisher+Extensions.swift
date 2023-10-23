//
//  Publisher+Extensions.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import Combine

public extension Publisher where Output == Never {

    func setOutputType<NewOutput>(
        to outputType: NewOutput.Type
    ) -> Publishers.Map<Self, NewOutput> {
        map { _ -> NewOutput in }
    }

    func andThen<T, P: Publisher>(
        _ publisher: P
    ) -> AnyPublisher<T, Failure> where P.Output == T, P.Failure == Failure {
        setOutputType(to: T.self)
            .compactMap { $0 }
            .append(publisher)
            .eraseToAnyPublisher()
    }

    func andThen<T, P: Publisher>(
        _ publisher: P
    ) -> AnyPublisher<T, Failure> where P.Output == T, P.Failure == Never {
        andThen(publisher.setFailureType(to: Failure.self))
    }

    func andThen<Element>(justReturn output: Element) -> AnyPublisher<Element, Failure> {
        andThen(Just(output))
    }
}

public extension Publisher {
    
    func ignoreFailure() -> AnyPublisher<Output, Never> {
        self.catch { _ in Empty<Output, Never>() }.eraseToAnyPublisher()
    }
}
