//
//  Data+Json.swift
//  RBNetworkingModule
//
//  Created by Rahmi Bozdağ on 14.09.2021.
//

import Foundation

public extension Data {
    func toPrettyPrintedJsonText() -> String {
        return toJsonText(options: [.prettyPrinted])
    }

    func toJsonText(options: JSONSerialization.WritingOptions = []) -> String {
        guard let object = toJsonObject(),
              let data = try? JSONSerialization.data(withJSONObject: object, options: options),
              let text = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return "" }

        return text as String
    }

    func toJsonObject() -> Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
}
