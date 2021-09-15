//
//  NetworkErrorConvertable.swift
//
//  Created by Rahmi Bozdağ on 31.01.2021.
//

import Foundation

protocol NetworkErrorConvertable {
    func toNetworkError() -> NetworkErrors
}

extension CFNetworkErrors: NetworkErrorConvertable {
    func toNetworkError() -> NetworkErrors {
        switch self {
        case .cfurlErrorCancelled:
            return NetworkErrors.cancelled
        case .cfurlErrorTimedOut:
            return NetworkErrors.timedOut
        default:
            return NetworkErrors.undefined
        }
    }
}

extension URLError: NetworkErrorConvertable {
    func toNetworkError() -> NetworkErrors {
        switch self {
        case URLError.cancelled:
            return NetworkErrors.cancelled
        case URLError.notConnectedToInternet:
            return NetworkErrors.notConnectedToInternet
        case URLError.timedOut:
            return NetworkErrors.timedOut
        case URLError.unsupportedURL:
            return NetworkErrors.unsupportedURL
        case URLError.cannotFindHost:
            return NetworkErrors.cannotFindHost
        default:
            return NetworkErrors.undefined
        }
    }
}

extension Error {
    func toNetworkError() -> NetworkErrors {
        if isUrlCancelled {
            return .cancelled
        } else if let error = self as? NetworkErrorConvertable {
            return error.toNetworkError()
        } else if let cfNetworkError = CFNetworkErrors(rawValue: Int32((self as NSError).code)) {
            return cfNetworkError.toNetworkError()
        }
        return NetworkErrors.undefined
    }

    var isUrlCancelled: Bool {
        let error = self as NSError
        return error.code == NSURLErrorCancelled
    }
}
