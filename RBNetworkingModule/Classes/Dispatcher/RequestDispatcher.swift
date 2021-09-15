//
//  RequestDispatcher.swift
//
//  Created by Rahmi Bozdağ on 30.01.2021.
//

import Foundation

public typealias NetworkDispatchCompletion = (DispatchResult) -> Void

public protocol RequestDispatcher {
    var requestInterceptors: [RequestInterceptor]? { get set }
    var responseInterceptors: [ResponseInterceptor]? { get set }
    func dispatch(urlRequest: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionTask?
}

public extension RequestDispatcher {
    func dispatch(request: Request, callBack: @escaping (RequestDispatchStatus) -> Void) {
        do {
            // build URLRequest
            var urlRequest = try request.buildURLRequest()

            // execute request dispatchers
            requestInterceptors?.forEach { urlRequest = $0.onRequest(request, urlRequest) }

            // notify initialized
            callBack(.initialized(urlRequest))

            // create task
            if let task = dispatch(urlRequest: urlRequest, completion: { result in self.handleResponse(request, urlRequest, result, callBack) }) {
                callBack(.dispatched(task))
                task.resume()
            } else {
                callBack(.failed(.taskNotCreated, nil))
            }
        } catch {
            callBack(.failed(error.toNetworkError(), nil))
        }
    }

    private func handleResponse(_ request: Request, _ urlRequest: URLRequest, _ result: DispatchResult, _ callBack: @escaping (RequestDispatchStatus) -> Void) {
        // execute response dispatchers
        var result = result
        responseInterceptors?.forEach { result = $0.onResponse(request, urlRequest, result) }

        let httpStatusEnum = (result.response as? HTTPURLResponse)?.statusEnum

        // check is cancelled
        if let error = result.error?.toNetworkError() {
            if error.isUrlCancelled {
                callBack(.cancelled)
            } else {
                callBack(.failed(error, httpStatusEnum))
            }
            return
        }

        // notify response handled
        callBack(.responded(result.data, result.response, httpStatusEnum))
    }
}
