//
//  DictionaryExtensionTests.swift
//  TransformersTests
//
//  Created by Carl Chen on 2018/4/12.
//  Copyright © 2018 nswebfrog. All rights reserved.
//

import XCTest
import Transformers

class DictionaryExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testKeyPath() {
        let jsonDicStr = """
{
    "k1": "2342",
    "k2": {
        "n1": 22,
        "n2": "peter"
    },
    "k3": {
        "x1": {
            "data": "fuck",
            "count": 112
        },
        "name": "beijing"
    }
}
"""
        guard let dic = jsonDicStr
            .data(using: String.Encoding.utf8)
            .flatMap({ $0.toDictionary() }) else {
            XCTFail()
            return
        }

        guard let k1Value: String = dic.value(keyPath: "k1") else {
            XCTFail()
            return
        }
        XCTAssertEqual(k1Value, "2342")

        guard let k2Value1: Int = dic.value(keyPath: "k2.n1") else {
            XCTFail()
            return
        }
        XCTAssertEqual(k2Value1, 22)

        guard let k3X1Value1: String = dic.value(keyPath: "k3.x1.data") else {
            XCTFail()
            return
        }
        XCTAssertEqual(k3X1Value1, "fuck")


    }

}
