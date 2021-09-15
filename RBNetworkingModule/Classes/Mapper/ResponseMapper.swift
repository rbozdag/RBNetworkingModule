//
//  ResponseMapper.swift
//
//  Created by Rahmi Bozdağ on 30.01.2021.
//

import Foundation

public enum ResponseMapper {
    static func convert<S: Decodable, E: Decodable & NetworkError>(_ data: Data?,
                                                                   _ error: NetworkErrors?,
                                                                   _ httpStatus: HTTPStatusCode?) -> ResponseMappingResult<S, E> {
        var data = data

        if httpStatus == HTTPStatusCode.noContent, data == nil {
            data = "{}".data(using: .utf8) // converting empty json
        }

        do {
            let decoder = JSONDecoder()
            if error != nil || httpStatus?.responseType.isErrorType ?? false {
                if let data = data {
                    var model = try decoder.decode(E.self, from: data)
                    model.error = error
                    model.httpStatus = httpStatus
                    return .failure(model)
                } else {
                    return .failure(.init(error: error, httpStatus: httpStatus))
                }
            } else if S.self == Data.self, let dataModel = data as? S { // primitive
                return .success(dataModel)
            } else if let data = data {
                let model = try decoder.decode(S.self, from: data)
                return .success(model)
            } else {
                return .failure(.init(error: error, httpStatus: httpStatus))
            }
        } catch {
            debugPrint(error)
            return .failure(.init(error: .decodingError, httpStatus: httpStatus))
        }
    }
}
