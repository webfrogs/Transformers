//
//  Dictionary+Extensions.swift
//  Transformers-iOS
//
//  Created by Carl Chen on 2018/4/11.
//  Copyright © 2018 nswebfrog. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {
    func value<T>(key: String) -> T? {
        return self[key].flatMap({ $0 as? T })
    }

    func value<T>(keyPath: String) -> T? {
        let keys = keyPath.components(separatedBy: ".")
        if keys.count == 1 {
            return value(key: keys[0])
        }
        var dic: [String: Any]? = self
        (0..<keys.count-1).forEach { (i) in
            dic = dic?.value(key: keys[i])
        }

        return dic?.value(key: keys[keys.count-1])
    }
}
