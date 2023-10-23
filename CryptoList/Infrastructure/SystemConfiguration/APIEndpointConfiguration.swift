//
//  APIEndpointConfiguration.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Foundation

public struct APIEndpointConfiguration: EndpointConfiguration {

    public init() {}

    public func url(
        applying path: String,
        queryItems: [URLQueryItem]
    ) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/\(path)"
        components.queryItems = queryItems 
            + [.init(name: "x_cg_demo_api_key", value: "CG-4YQi2D98pKKcxKuozLCs7k4J")]
        return components.url
    }

    public func configureRequest(
        url: URL,
        method: HTTPMethod,
        body: Data?
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
