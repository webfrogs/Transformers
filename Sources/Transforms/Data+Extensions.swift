//
//  Data+Extensions.swift
//  Transformers-iOS
//
//  Created by Carl Chen on 2018/4/11.
//  Copyright © 2018 nswebfrog. All rights reserved.
//

import Foundation

public struct Errors {
    public enum Json: Error {
        case toModelFailed
        case toModelArrayFailed
    }
}

public extension Data {
    func toDictionary() -> [String: Any]? {
        return p_serialize() as? [String: Any]
    }

    func toArray<T>() -> [T]? {
        return p_serialize() as? [T]
    }

    func jsonToModel<T>() -> T? where T: Codable {
        let model = try? JSONDecoder().decode(T.self, from: self)
        return model
    }

    func jsonToModelArray<T>() -> [T]? where T: Codable {
        let modelArray = try? JSONDecoder().decode([T].self, from: self)
        return modelArray
    }

    static func jsonToModelHandler<T>(data: Data) throws -> T where T: Codable {
        guard let result: T = data.jsonToModel() else {
            throw Errors.Json.toModelFailed
        }
        return result
    }

    static func jsonToModelArrayHandler<T>(data: Data) throws -> [T] where T: Codable {
        guard let result: [T] = data.jsonToModelArray() else {
            throw Errors.Json.toModelArrayFailed
        }
        return result
    }
}

private extension Data {
    func p_serialize() -> Any? {
        let obj = try? JSONSerialization.jsonObject(with: self, options: [])
        return obj
    }
}
