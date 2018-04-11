//
//  Data+Extensions.swift
//  Transformers-iOS
//
//  Created by Carl Chen on 2018/4/11.
//  Copyright © 2018 nswebfrog. All rights reserved.
//

import Foundation

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
}

private extension Data {
    func p_serialize() -> Any? {
        let obj = try? JSONSerialization.jsonObject(with: self, options: [])
        return obj
    }
}
