//
//  RequestInterceptor.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public protocol RequestInterceptor {
    func onRequest(_ request: Request, _ urlRequest: URLRequest) -> URLRequest
}
