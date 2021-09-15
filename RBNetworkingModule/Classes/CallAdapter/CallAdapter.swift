//
//  CallAdapter.swift
//
//  Created by Rahmi Bozdağ on 8.02.2021.
//

import Foundation

public protocol CallAdapter {
    func submit<S: Decodable, E: Decodable & NetworkError>(dispatcher: RequestDispatcher, request: Request,
                                                           onSucceeded: @escaping (S) -> Void, onFailed: @escaping (E) -> Void)
}

public extension CallAdapter {
    func submit<S: Decodable, E: Decodable & NetworkError>(dispatcher: RequestDispatcher, request: Request,
                                                           onSucceeded: @escaping (S) -> Void, onFailed: @escaping (E) -> Void) {
        dispatcher.dispatch(request: request) { status in
            switch status {
            case let .responded(data, _, httpStatus):
                let response: ResponseMappingResult<S, E> = ResponseMapper.convert(data, nil, httpStatus)
                DispatchQueue.main.async {
                    if let model = response.value {
                        onSucceeded(model)
                    } else {
                        onFailed(response.error ?? E(error: .undefined, httpStatus: httpStatus))
                    }
                }
            case let .failed(error, httpStatus):
                let error = E(error: error, httpStatus: httpStatus)
                DispatchQueue.main.async {
                    onFailed(error)
                }
            default:
                break
            }
        }
    }
}
