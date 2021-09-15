//
//  RequestDispatchStatus.swift
//
//  Created by Rahmi Bozdağ on 30.01.2021.
//

import Foundation

public enum RequestDispatchStatus {
    case initialized(_ request: URLRequest)
    case dispatched(_ task: URLSessionTask)
    case responded(_ data: Data?, _ response: URLResponse?, _ httpStatus: HTTPStatusCode?)
    case failed(_ error: NetworkErrors, _ httpStatus: HTTPStatusCode?)
    case cancelled
}

public struct DispatchResult {
    public let data: Data?
    public let response: URLResponse?
    public let error: Error?
}
