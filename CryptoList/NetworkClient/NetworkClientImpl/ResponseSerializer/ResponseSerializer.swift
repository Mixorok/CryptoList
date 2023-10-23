//
//  ResponseSerializer.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Foundation

public protocol ResponseSerializer {
    func decode<T: Decodable>(_ type: T.Type, from data: DataPayload) throws -> T
}
