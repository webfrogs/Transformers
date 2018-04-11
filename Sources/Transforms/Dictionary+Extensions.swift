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
}
