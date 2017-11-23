//
//  Dictionary.swift
//  Transformers-iOS
//
//  Created by Carl Chen on 23/11/2017.
//  Copyright © 2017 nswebfrog. All rights reserved.
//

import Foundation

public struct Dictionary {
    public enum Errors: Error {
        case noValueFromKey(String)
        case valueTypeWrong(String, Any)
        case notJson(Any)
        case toModelFailed(String)
    }

    public static func value<T>(key: String) -> ([String: Any]) throws -> T {
        return { (dic: [String: Any]) -> T in
            guard let value = dic[key] else {
                throw Errors.noValueFromKey(key)
            }

            guard let result = value as? T else {
                throw Errors.valueTypeWrong(String(describing: T.self), value)
            }
            return result
        }
    }

    public func toModel<T>(_ dic: [String: Any]) throws -> T where T: Codable {
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dic
                , options: JSONSerialization.WritingOptions())
        } catch {
            throw Errors.notJson(dic)
        }

        do {
            return try JSONDecoder().decode(T.self, from: jsonData)
        } catch {
            throw Errors.toModelFailed(String(describing: T.self))
        }
    }
}
