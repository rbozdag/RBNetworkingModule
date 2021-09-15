//
//  UrlQueryValueRepresentable.swift
//
//  Created by Rahmi Bozdağ on 29.01.2021.
//

import Foundation

public protocol UrlQueryValueRepresentable {
    var urlQueryValue: String? { get }
}

extension String: UrlQueryValueRepresentable {
    public var urlQueryValue: String? {
        return self
    }
}

extension Int: UrlQueryValueRepresentable {
    public var urlQueryValue: String? {
        return String(self)
    }
}

extension Double: UrlQueryValueRepresentable {
    public var urlQueryValue: String? {
        return String(format: "%0lf", self)
    }
}

extension Float: UrlQueryValueRepresentable {
    public var urlQueryValue: String? {
        return String(format: "%0lf", self)
    }
}

extension UrlQueryValueRepresentable where Self: RawRepresentable, Self.RawValue == String {
    var urlQueryValue: String? {
        return rawValue.urlQueryValue
    }
}
