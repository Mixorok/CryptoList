//
//  CustomAsyncImageRenderer.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 23.10.2023.
//

import SwiftUI

public protocol CustomAsyncImageRenderer {
    @ViewBuilder func renderImage<Content: View, Placeholder: View, ID: Hashable>(
        by id: ID,
        for url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) -> AnyView
}

