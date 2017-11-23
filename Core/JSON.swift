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
            case toArrayFailed(obj: Any, itemType: String)
        }

        public static let toDictionary: (Any) throws -> [String: Any] = {
            (obj: Any) -> [String: Any] in
            guard let dic = obj as? [String: Any] else {
                throw Errors.toDictionaryFailed(obj)
            }
            return dic
        }

        public static func toArray<T>(_ obj: Any) throws -> [T] {
            guard let result = obj as? [T] else {
                throw Errors.toArrayFailed(obj: obj, itemType: String(describing: T.self))
            }
            return result
        }
    }


    public struct Dictionary {
        public enum Errors: Error {
            case noValue(key: String)
            case valueTypeWrong(value: Any, type: String)
            case notJson(Any)
            case toModelFailed(String)
        }

        public static func value<T>(key: String) -> ([String: Any]) throws -> T {
            return { (dic: [String: Any]) -> T in
                guard let value = dic[key] else {
                    throw Errors.noValue(key: key)
                }

                guard let result = value as? T else {
                    throw Errors.valueTypeWrong(value: value, type: String(describing: T.self))
                }
                return result
            }
        }

        public static func toModel<T>(_ dic: [String: Any]) throws -> T where T: Codable {
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
            case toModelArrayFailed(failedItem: Any, type: String)
        }

        public static func toModelArray<T>(_ dicArray: [[String: Any]]) throws -> [T]
        where T: Codable {
            let result: [T] = try dicArray.flatMap { (dic) -> T? in
                do {
                    let dicData = try JSONSerialization.data(withJSONObject: dic
                        , options: JSONSerialization.WritingOptions())
                    return try JSONDecoder().decode(T.self, from: dicData)
                } catch {
                    throw Errors.toModelArrayFailed(failedItem: dic
                        , type: String(describing: T.self))
                }
            }

            return result
        }

        public static func toModelArrayWithoutError<T>(_ dicArray: [[String: Any]]) -> [T]
        where T: Codable {
            let result: [T] = dicArray.flatMap { (dic) -> T? in
                do {
                    let dicData = try JSONSerialization.data(withJSONObject: dic
                        , options: JSONSerialization.WritingOptions())
                    return try JSONDecoder().decode(T.self, from: dicData)
                } catch {
                    return nil
                }
            }

            return result
        }
    }

}

