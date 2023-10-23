//
//  ImageLoaderRepository.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 23.10.2023.
//

import Combine
import Foundation

public protocol ImageLoaderRepository {
    func fetchImage(for url: URL) -> AnyPublisher<Data, Error>
}
