//
//  ImageLoaderRepositoryImpl.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 23.10.2023.
//

import Combine
import Foundation

public final class ImageLoaderRepositoryImpl: ImageLoaderRepository {

    private let urlSession: URLSession

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func fetchImage(for url: URL) -> AnyPublisher<Data, Error> {
        Just(urlSession.configuration.urlCache?.cachedResponse(for: URLRequest(url: url)))
            .flatMap { [urlSession] cachedImage in
                if let cachedImage {
                    return Just(cachedImage.data)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return urlSession.dataTaskPublisher(for: url)
                    .tryMap(\.data)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

