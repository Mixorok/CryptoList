//
//  CustomAsyncImageRendererImpl.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 23.10.2023.
//

import SwiftUI

public struct CustomAsyncImageRendererImpl<
    ImageCoordinator: ImageCacheCoordinator
>: CustomAsyncImageRenderer {

    private var imageCoordinator: ImageCoordinator

    public init(imageCoordinator: ImageCoordinator) {
        self.imageCoordinator = imageCoordinator
    }

    @ViewBuilder public func renderImage(
        by id: some Hashable,
        for url: URL?,
        @ViewBuilder content: @escaping (Image) -> some View,
        @ViewBuilder placeholder: @escaping () -> some View
    ) -> AnyView {
        CustomAsyncImageView(
            url: url,
            content: content,
            placeholder: placeholder,
            imageCoordinator: imageCoordinator
        )
        .id(id)
        .asAny()
    }
}

private struct CustomAsyncImageView<
    Content: View,
    Placeholder: View,
    ImageCoordinator: ImageCacheCoordinator
>: View {

    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var asyncImage: Image?
    @ObservedObject private var imageCoordinator: ImageCoordinator

    init(
        url: URL?,
        content: @escaping (Image) -> Content,
        placeholder: @escaping () -> Placeholder,
        imageCoordinator: ImageCoordinator
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        _imageCoordinator = ObservedObject(wrappedValue: imageCoordinator)
    }

    var body: some View {
        ZStack {
            if let asyncImage {
                content(asyncImage)
            } else {
                placeholder()
            }
        }
        .animation(.easeIn(duration: 0.2), value: asyncImage)
        .task(id: url) {
            asyncImage = await imageCoordinator.getImage(for: url)
        }
    }
}

