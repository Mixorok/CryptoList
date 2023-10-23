//
//  ImageCacheCoordinator.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 23.10.2023.
//

import Combine
import SwiftUI

public protocol ImageCacheCoordinator: ObservableObject {
    func getImage(for url: URL?) async -> Image?
}

public final class ImageCacheCoordinatorImpl: ImageCacheCoordinator {

    private let getImageData: ImageLoaderRepository

    @Published private var images: [URL: Image] = [:]

    public init(getImageData: ImageLoaderRepository) {
        self.getImageData = getImageData
    }

    @MainActor
    public func getImage(for url: URL?) async -> Image? {
        guard let url else { return nil }
        if let image = images[url] { return image }
        for await image in fetchImage(for: url).values {
            images[url] = image
            return image
        }
        return nil
    }

    private func fetchImage(for url: URL) -> AnyPublisher<Image, Never> {
        getImageData.fetchImage(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .ignoreFailure()
            .compactMap(UIImage.init)
            .map(Image.init)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

