//
//  JSONResponseSerializer.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Foundation

public struct JSONResponseSerializer: ResponseSerializer {

    private let decoder = JSONDecoder()

    public init() {}

    public func decode<T: Decodable>(_ type: T.Type, from dataPayload: DataPayload) throws -> T {
        do {
            return try decoder.decode(type, from: dataPayload.data)
        } catch let error {
            throw NetworkClientError.responseSerializationError(error)
        }
    }
}
