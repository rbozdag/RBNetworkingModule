//
//  RequestParameters+Query.swift
//
//  Created by Rahmi Bozdağ on 8.02.2021.
//

import Foundation

public extension RequestParameters {
    func mapURLQueryItems() -> [URLQueryItem] {
        return map { item -> URLQueryItem in
            var encodedParam: String?
            if let queryRepresentable = item.value as? UrlQueryValueRepresentable {
                encodedParam = queryRepresentable.urlQueryValue
            } else {
                encodedParam = "\(item.value)"
            }
            return URLQueryItem(name: item.key, value: encodedParam)
        }
    }
}
