//
//  ConfigurableNetworkClient.swift
//  CryptoList
//
//  Created by Maksim Bezdrobnoi on 20.10.2023.
//

import Combine
import Foundation

public struct ConfigurableNetworkClient: NetworkClient {

    private let session: URLSession
    private let requestSerializer: RequestSerializer
    private let responseSerializer: ResponseSerializer
    private let endpointConfiguration: EndpointConfiguration

    public init(
        session: URLSession,
        requestSerializer: RequestSerializer,
        responseSerializer: ResponseSerializer,
        endpointConfiguration: EndpointConfiguration
    ) {
        self.session = session
        self.requestSerializer = requestSerializer
        self.responseSerializer = responseSerializer
        self.endpointConfiguration = endpointConfiguration
    }

    public func execute<ResponseBody: Decodable>(
        method: HTTPMethod,
        path: String,
        queryItems: [URLQueryItem] = [],
        body: (some Encodable)?,
        responseType: ResponseBody.Type
    ) -> AnyPublisher<ResponseBody, Error> {
        let url: URL
        do {
            url = try prepareURL(path: path, queryItems: queryItems)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return prepareRequest(
            method: method,
            url: url,
            body: body
        )
        .flatMap { request in
            session.dataTaskPublisher(for: request)
                .mapError { $0 as Error }
                .map { data, response in
                    let dataPayload = DataPayload(data: data, urlRequest: request)
                    return (dataPayload, response)
                }
        }
        .tryMap { dataPayload, response in
            try response.validate(dataPayload: dataPayload)
        }
        .receive(on: DispatchQueue.main)
        .handleEvents(
            receiveOutput: { _ in print("StatusCode: \(method.rawValue) 200 for \(path)") },
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Client Error: \(error)")
                }
            }
        )
        .tryMap { try responseSerializer.decode(ResponseBody.self, from: $0) }
        .eraseToAnyPublisher()
    }

    private func prepareURL(
        path: String,
        queryItems: [URLQueryItem]
    ) throws -> URL {
        guard let url = endpointConfiguration.url(applying: path, queryItems: queryItems) else {
            throw NetworkClientError.failedToGenerateURL(path)
        }
        return url
    }

    private func prepareRequest(
        method: HTTPMethod,
        url: URL,
        body: (some Encodable)?
    ) -> AnyPublisher<URLRequest, Error> {
        Deferred {
            try requestSerializer.configureContentType(
                on: endpointConfiguration.configureRequest(
                    url: url,
                    method: method,
                    body: body.map(requestSerializer.encode)
                )
            )
        }
        .eraseToAnyPublisher()
    }
}

private extension URLResponse {

    func validate(dataPayload: DataPayload) throws -> DataPayload {
        guard let response = self as? HTTPURLResponse else {
            fatalError("Could not downcast response")
        }
        guard (200...299).contains(response.statusCode) else {
            print("NetworkClient received negative statusCode: \(response)")
            throw NetworkClientError.invalidStatusCode(response.statusCode)
        }
        return dataPayload
    }
}
