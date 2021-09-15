//
//  UrlSessionRequestDispatcher.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public final class UrlSessionRequestDispatcher: RequestDispatcher {
    public var requestInterceptors: [RequestInterceptor]?
    public var responseInterceptors: [ResponseInterceptor]?
    private let session: URLSession

    public init(session: URLSession, requestInterceptors: [RequestInterceptor]? = nil, responseInterceptors: [ResponseInterceptor]? = nil) {
        self.session = session
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }

    public func dispatch(urlRequest: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionTask? {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion(DispatchResult(data: data, response: response, error: error))
        }
        return task
    }
}
