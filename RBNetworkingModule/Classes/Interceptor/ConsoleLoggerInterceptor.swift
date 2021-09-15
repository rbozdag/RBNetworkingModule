//
//  ConsoleLoggerInterceptor.swift
//
//  Created by Rahmi Bozdağ on 31.01.2021.
//

import Foundation

public struct ConsoleLoggerInterceptor {
    public init() { /* public access */ }
}

extension ConsoleLoggerInterceptor: RequestInterceptor {
    public func onRequest(_: Request, _ request: URLRequest) -> URLRequest {
        var logs = [String]()
        logs.append("Request Detail")
        logs.append("• url: \(request.url?.absoluteString ?? "-")")
        logs.append("• method: \(request.httpMethod ?? "-")")

        if let json = request.httpBody?.toPrettyPrintedJsonText(), json.count > 0 {
            logs.append("• body(json):\n   \(json.replacingOccurrences(of: "\n", with: "\n   "))")
        } else if let base64 = request.httpBody?.base64EncodedString(), base64.count > 0 {
            logs.append("• body(base64): \(base64)")
        } else if let data = request.httpBody {
            logs.append("• body(data byte count): \(data.count)")
        }

        print("\n--------------------------------------------------------------------------------------------------------",
              logs.reduce(" ") { "\($0)\n \($1)" },
              "\n--------------------------------------------------------------------------------------------------------\n")
        return request
    }
}

extension ConsoleLoggerInterceptor: ResponseInterceptor {
    public func onResponse(_: Request, _ request: URLRequest, _ result: DispatchResult) -> DispatchResult {
        var logs = [String]()
        logs.append("Response Detail")
        logs.append("• url: \(request.url?.absoluteString ?? "-")")
        logs.append("• method: \(request.httpMethod ?? "-")")
        if let headers = request.allHTTPHeaderFields, headers.count > 0 {
            logs.append("• headers")
            logs.append(contentsOf: headers.map { "  -\($0.key) - \($0.value)" })
        }

        if let status = (result.response as? HTTPURLResponse)?.statusEnum {
            logs.append("• status: \(status.rawValue)")
        } else {
            logs.append("• status: unknown")
        }

        if let error = result.error {
            logs.append("• error: \(error.localizedDescription)")
        }

        if let json = result.data?.toPrettyPrintedJsonText(), json.count > 0 {
            logs.append("• data(json):\n   \(json.replacingOccurrences(of: "\n", with: "\n   "))")
        } else if let data = result.data, let base64 = result.data?.base64EncodedString(), base64.count > 0 {
            logs.append("• data(base64): \(base64)")
            logs.append("• data(String): \(String(data: data, encoding: .utf8) ?? "-")")
        } else if let data = result.data {
            logs.append("• data(data byte count): \(data.count)")
        } else {
            logs.append("• data: empty")
        }

        print("\n--------------------------------------------------------------------------------------------------------",
              logs.reduce(" ") { "\($0)\n \($1)" },
              "\n--------------------------------------------------------------------------------------------------------\n")
        return result
    }
}
