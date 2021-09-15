//
//  HTTPHeaderKey.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public typealias RequestHTTPHeaders = [String: String]

public enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
    case acceptLanguage = "Accept-Language"
    case acceptType = "Accept"
    case authorization = "Authorization"
}
