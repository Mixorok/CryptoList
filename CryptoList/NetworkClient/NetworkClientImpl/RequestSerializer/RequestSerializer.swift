//
//  RequestSerializer.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Foundation

public protocol RequestSerializer {
    func encode<T: Encodable>(_ value: T) throws -> Data
    func configureContentType(on urlRequest: URLRequest) -> URLRequest
}
