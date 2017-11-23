//
//  JSON.swift
//  Transformers
//
//  Created by Carl Chen on 23/11/2017.
//  Copyright © 2017 nswebfrog. All rights reserved.
//

import Foundation

public struct Transformer {
    public struct JSON {
        public enum Errors: Error {
            case toDictionaryFailed(Any)
            case toArrayFailed(Any)
            case toTypedArrayFailed(Any)
        }

        public static let toDictionary: (Any) throws -> [String: Any] = {
            (obj: Any) -> [String: Any] in
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


    public struct Array {
        public enum Errors: Error {
            case notJson(Any)
            case toModelArrayFailed(String)
        }

        public func toModelArray<T>(shouldThrow: Bool = false)
            -> ( [[String: Any]]) throws -> [T] where T: Codable {
                return { (dicArray) -> [T] in
                    let result: [T] = try dicArray.flatMap { (dic) -> T? in
                        do {
                            let dicData = try JSONSerialization.data(withJSONObject: dic
                                , options: JSONSerialization.WritingOptions())
                            return try JSONDecoder().decode(T.self, from: dicData)
                        } catch {
                            if shouldThrow {
                                throw Errors.toModelArrayFailed(String(describing: T.self))
                            } else {
                                return nil
                            }
                        }
                    }

                    return result
                }
            }
    }

}

