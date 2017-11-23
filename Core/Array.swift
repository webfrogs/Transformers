//
//  Array.swift
//  Transformers-iOS
//
//  Created by Carl Chen on 23/11/2017.
//  Copyright © 2017 nswebfrog. All rights reserved.
//

import Foundation

public struct Array {
    public enum Errors: Error {
        case notJson(Any)
        case toModelArrayFailed(String)
    }

    public func toModelArray<T>(_ dicArray: [[String: Any]]
        , throwWhenError: Bool = false) throws -> [T] where T: Codable {

        let result: [T] = try dicArray.flatMap { (dic) -> T? in
            do {
                let dicData = try JSONSerialization.data(withJSONObject: dic
                    , options: JSONSerialization.WritingOptions())
                return try JSONDecoder().decode(T.self, from: dicData)
            } catch {
                if throwWhenError {
                    throw Errors.toModelArrayFailed(String(describing: T.self))
                } else {
                    return nil
                }
            }
        }

        return result
    }
}
