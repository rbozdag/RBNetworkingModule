//
//  UrlRequestFormUrlEncoder.swift
//
//  Created by Rahmi Bozdağ on 8.02.2021.
//

import Foundation

public struct UrlRequestFormUrlEncoder: UrlRequestParameterEncoder {
    public init() { /* public access */ }

    public func encode(urlRequest: URLRequest, with parameters: RequestParameters?) throws -> URLRequest {
        var urlRequest = urlRequest
        var urlComponents = URLComponents()
        urlComponents.queryItems = parameters?.mapURLQueryItems()
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        return urlRequest
    }
}
