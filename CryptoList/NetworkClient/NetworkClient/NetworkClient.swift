//
//  NetworkClient.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Combine
import Foundation

public protocol NetworkClient {

    func execute<RequestBody: Encodable, ResponseBody: Decodable>(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem],
        body: RequestBody?,
        responseType: ResponseBody.Type
    ) -> AnyPublisher<ResponseBody, Error>
}
