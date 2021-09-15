//
//  Request+buildURLRequest.swift
//
//  Created by Rahmi Bozdağ on 30.01.2021.
//

import Foundation

public extension Request {
    var absoluteURL: URL {
        return baseUrl.appendingPathComponent(path)
    }

    func buildURLRequest() throws -> URLRequest {
        var request = URLRequest(url: absoluteURL)
        request.httpMethod = method.rawValue
        request = prepareHeader(for: request)
        request = try parameterEncoder.encode(urlRequest: request, with: parameters)
        return request
    }

    private func prepareHeader(for request: URLRequest) -> URLRequest {
        var request = request
        request = insertMimeTypes(request)
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    private func insertMimeTypes(_ request: URLRequest) -> URLRequest {
        var request = request
        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
        }
        request.setValue(acceptType.rawValue, forHTTPHeaderField: HTTPHeaderKey.acceptType.rawValue)
        return request
    }
}
