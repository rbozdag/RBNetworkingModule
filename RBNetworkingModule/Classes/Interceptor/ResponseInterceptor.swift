//
//  ResponseInterceptor.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public protocol ResponseInterceptor {
    func onResponse(_ request: Request, _ request: URLRequest, _ result: DispatchResult)
        -> DispatchResult
}
