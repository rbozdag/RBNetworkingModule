//
//  RxCallAdapter.swift
//
//  Created by Rahmi Bozdağ on 30.01.2021.
//

import Foundation
import RxSwift

public protocol RxCallAdapter {
    func create<S: Decodable, E: Decodable & NetworkError>(dispatcher: RequestDispatcher, request: Request) -> Maybe<ResponseMappingResult<S, E>>
}

public extension RxCallAdapter {
    func create<S: Decodable, E: Decodable & NetworkError>(dispatcher: RequestDispatcher, request: Request) -> Maybe<ResponseMappingResult<S, E>> {
        return Maybe<ResponseMappingResult<S, E>>.create { maybe -> Disposable in
            var task: URLSessionTask?
            dispatcher.dispatch(request: request) { status in
                switch status {
                case let .dispatched(taskPrm):
                    task = taskPrm
                case let .responded(data, _, httpStatus):
                    let response: ResponseMappingResult<S, E> = ResponseMapper.convert(data, nil, httpStatus)
                    maybe(.success(response))
                case let .failed(error, httpStatus):
                    let networkError = E(error: error, httpStatus: httpStatus)
                    let response = ResponseMappingResult<S, E>.failure(networkError)
                    maybe(.success(response))
                case .cancelled:
                    maybe(.completed)
                default:
                    break
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }
}
