//
//  DataPayload.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Foundation

public struct DataPayload {

    public let data: Data
    public let urlRequest: URLRequest

    public init(data: Data, urlRequest: URLRequest) {
        self.data = data
        self.urlRequest = urlRequest
    }
}

