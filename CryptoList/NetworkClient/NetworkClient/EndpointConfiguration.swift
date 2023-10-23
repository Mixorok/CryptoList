//
//  EndpointConfiguration.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Foundation

public protocol EndpointConfiguration {
    func url(applying path: String, queryItems: [URLQueryItem]) -> URL?
    func configureRequest(url: URL, method: HTTPMethod, body: Data?) -> URLRequest
}
