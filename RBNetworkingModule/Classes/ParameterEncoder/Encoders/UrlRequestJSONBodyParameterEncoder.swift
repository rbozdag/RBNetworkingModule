//
//  UrlRequestJSONBodyUrlRequestParameterEncoder.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public struct UrlRequestJSONBodyUrlRequestParameterEncoder: UrlRequestParameterEncoder {
    public init() { /* public access */ }

    public func encode(urlRequest: URLRequest, with parameters: RequestParameters?) throws -> URLRequest {
        guard let parameters = parameters else {
            return urlRequest
        }
        do {
            var urlRequest = urlRequest
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
        } catch {
            throw NetworkErrors.urlEncodingFailed
        }
    }
}
