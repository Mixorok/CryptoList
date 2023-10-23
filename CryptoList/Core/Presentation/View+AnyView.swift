//
//  View+AnyView.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import SwiftUI

public extension View {

    func asAny() -> AnyView { AnyView(self) }
}
