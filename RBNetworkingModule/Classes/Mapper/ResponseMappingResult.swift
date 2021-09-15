//
//  ResponseMappingResult.swift
//
//  Created by Rahmi Bozdağ on 31.01.2021.
//

import Foundation

public protocol ResponseMappingResultType {
    associatedtype SuccessType
    associatedtype ErrorType
}

public enum ResponseMappingResult<S, E> {
    case success(S)
    case failure(E)
}

public extension ResponseMappingResult {
    var value: S? {
        guard case let Self.success(value) = self else { return nil }
        return value
    }

    var error: E? {
        guard case let Self.failure(error) = self else { return nil }
        return error
    }
}
