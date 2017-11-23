//
//  JSON.swift
//  Transformers
//
//  Created by Carl Chen on 23/11/2017.
//  Copyright © 2017 nswebfrog. All rights reserved.
//

import Foundation

public struct JSON {
    public enum Errors: Error {
        case toDictionaryFailed(Any)
        case toArrayFailed(Any)
        case toTypedArrayFailed(Any)
    }

    public static let toDictionary: (Any) throws -> [String: Any] = { (obj: Any) -> [String: Any] in
        guard let dic = obj as? [String: Any] else {
            throw Errors.toDictionaryFailed(obj)
        }
        return dic
    }

    public static let toArray: (Any) throws -> [Any] = { (obj: Any) -> [Any] in
        guard let array = obj as? [Any] else {
            throw Errors.toArrayFailed(obj)
        }
        return array
    }

    public static func toTypedArray<T>(_ obj: Any) throws -> [T] {
        guard let result = obj as? [T] else {
            throw Errors.toTypedArrayFailed(obj)
        }
        return result
    }
}
