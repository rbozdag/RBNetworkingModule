//
//  NetworkErrors.swift
//
//  Created by Rahmi Bozdağ on 30.01.2021.
//

import Foundation

public protocol NetworkError {
    var error: NetworkErrors? { get set }
    var httpStatus: HTTPStatusCode? { get set }
    init(error: NetworkErrors?, httpStatus: HTTPStatusCode?)
}

public enum NetworkErrors: Int, Error, Codable {
    case undefined
    case notConnectedToInternet
    case cancelled
    case timedOut
    case invalidContentType
    case noAcceptableMethod
    case badParamater
    case urlEncodingFailed
    case missingURL
    case decodingError
    case nilResponse
    case nilData
    case unknownHttpStatus
    case taskNotCreated
    case invalidChecksum
    case unsupportedURL
    case cannotFindHost
    case invalidSecurity
}
