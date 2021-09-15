//
//  UrlRequestQueryEncoder.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public struct UrlRequestQueryEncoder: UrlRequestParameterEncoder {
    public init() { /* public access */ }
    public func encode(urlRequest: URLRequest, with parameters: RequestParameters?) throws -> URLRequest {
        guard let url = urlRequest.url else { throw NetworkErrors.missingURL }
        guard let parameters = parameters else { return urlRequest }
        var urlRequest = urlRequest
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = urlComponents.queryItems ?? [URLQueryItem]()
            urlComponents.queryItems?.append(contentsOf: parameters.mapURLQueryItems())
            urlRequest.url = urlComponents.url
        }
        return urlRequest
    }
}
