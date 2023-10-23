//
//  NetworkClient+Extension.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Combine
import Foundation

public extension NetworkClient {

    func get<ResponseBody: Decodable>(
        _ responseType: ResponseBody.Type,
        path: String,
        queryItems: [URLQueryItem] = []
    ) -> AnyPublisher<ResponseBody, Error> {
        execute(
            method: .get,
            path: path,
            queryItems: queryItems,
            body: EmptyRequestEntity?.none,
            responseType: responseType
        )
    }
}

private struct EmptyRequestEntity: Encodable {}
private struct EmptyResponseEntity: Decodable {}
