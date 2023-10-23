//
//  AnyPublisher+ConvenientSink.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 21.10.2023.
//

import Combine

public extension Publisher {

    func sink(
        receiveValue: @escaping (Self.Output) -> Void = { _ in },
        receiveSuccess: @escaping () -> Void = {},
        receiveFailure: @escaping (Failure) -> Void = { _ in }
    ) -> AnyCancellable {
        sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    receiveSuccess()
                case .failure(let error):
                    receiveFailure(error)
                }
            },
            receiveValue: { receiveValue($0) }
        )
    }
}

