//
//  Request.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public protocol Request {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: MimeType? { get }
    var acceptType: MimeType { get }
    var parameters: RequestParameters? { get }
    var headers: RequestHTTPHeaders? { get }
    var parameterEncoder: UrlRequestParameterEncoder { get }
}
