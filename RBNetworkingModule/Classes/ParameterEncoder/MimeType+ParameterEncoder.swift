//
//  MimeType+ParameterEncoder.swift
//
//  Created by Rahmi Bozdağ on 8.02.2021.
//

import Foundation

public extension Optional where Wrapped == MimeType {
    func getEncoder() -> UrlRequestParameterEncoder {
        guard let self = self else { return UrlRequestQueryEncoder() }
        switch self {
        case .applicationJson:
            return UrlRequestJSONBodyUrlRequestParameterEncoder()
        case .formUrlEncoded:
            return UrlRequestFormUrlEncoder()
        }
    }
}
