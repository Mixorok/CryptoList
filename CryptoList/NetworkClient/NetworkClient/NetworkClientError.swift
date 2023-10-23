//
//  NetworkClientError.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

public enum NetworkClientError: Error {
    case failedToGenerateURL(String)
    case unrecognizedError
    case invalidStatusCode(Int)
    case responseSerializationError(Error)
    case requestSerializer(Error)
}

