//
//  ParameterEncoding.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public typealias RequestParameters = [String: Any]

public protocol UrlRequestParameterEncoder {
    func encode(urlRequest: URLRequest, with parameters: RequestParameters?) throws -> URLRequest
}
