//
//  Request+Common.swift
//
//  Created by Rahmi Bozdağ on 8.02.2021.
//

import Foundation

public extension Request {
    var parameterEncoder: UrlRequestParameterEncoder { contentType.getEncoder() }
    var contentType: MimeType? {
        if method == .get || method == .delete {
            return nil
        } else {
            return .applicationJson
        }
    }

    var acceptType: MimeType { .applicationJson }
    var headers: RequestHTTPHeaders? { nil }
    var parameters: RequestParameters? { nil }
}

public extension Request where Self: Encodable {
    var parameters: RequestParameters? { convertToReqestParameters() }

    func convertToReqestParameters() -> RequestParameters? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let dict = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? RequestParameters) as RequestParameters??) else { return nil }
        return dict
    }
}
