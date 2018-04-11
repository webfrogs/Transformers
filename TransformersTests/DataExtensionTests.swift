//
//  DataExtensionTests.swift
//  TransformersTests
//
//  Created by Carl Chen on 2018/4/11.
//  Copyright © 2018 nswebfrog. All rights reserved.
//

import XCTest
import Transformers

class DataExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testToDicNotNil() {
        let jsonDicStr = """
{
    "k1": "2342",
    "k2": 2222,
    "k3": "just a test"
}
"""

        let dic = jsonDicStr
            .data(using: String.Encoding.utf8)
            .flatMap({ $0.toDictionary() })

        guard let dic2 = dic else {
            XCTFail()
            return
        }
        XCTAssert(dic2.count == 3)

        guard let value1 = dic2["k1"] as? String else {
            XCTFail()
            return
        }
        XCTAssert(value1 == "2342")
        XCTAssert(dic2.value(key: "k1") == "2342")

        guard let value2 = dic2["k2"] as? Int else {
            XCTFail()
            return
        }
        XCTAssertEqual(value2, 2222)
        XCTAssert(dic2.value(key: "k2") == 2222)

        guard let value3 = dic2["k3"] as? String else {
            XCTFail()
            return
        }
        XCTAssertEqual(value3, "just a test")
        XCTAssert(dic2.value(key: "k3") == "just a test")


    }

    func testToDicNil() {
        let dic = "[]"
            .data(using: String.Encoding.utf8)
            .flatMap({ $0.toDictionary() })
        XCTAssertNil(dic)
    }

    func testToArrayNotNil() {
        let jsonArrayStr = """
[
    1,
    2,
    4,
    3
]
"""

        let array: [Any]? = jsonArrayStr
            .data(using: String.Encoding.utf8)
            .flatMap({ $0.toArray() })
        XCTAssertNotNil(array)
        XCTAssert(array?.count == 4)

        let array2: [Int]? = jsonArrayStr
            .data(using: String.Encoding.utf8)
            .flatMap({ $0.toArray() })
        XCTAssertNotNil(array2)
        XCTAssert(array2?.count == 4)
        XCTAssert(array2?[3] == 3)
    }

    func testJsonToModel() {
        let jsonStr = """
{
    "name": "carl",
    "age": 18
}
"""
        guard let model: Person = jsonStr.data(using: String.Encoding.utf8)
            .flatMap({ $0.jsonToModel() }) else {
                XCTFail()
                return
        }
        XCTAssertEqual(model.name, "carl")
        XCTAssertEqual(model.age, 18)

    }

    func testJsonToModelArray() {
        let jsonStr = """
[
{
    "name": "carl",
    "age": 18
},
{
    "name": "lydia",
    "age": 16
}
]
"""
        guard let modelArray: [Person] = jsonStr.data(using: String.Encoding.utf8)
            .flatMap({ $0.jsonToModel() }) else {
                XCTFail()
                return
        }
        XCTAssertEqual(modelArray.count, 2)
        XCTAssertEqual(modelArray[0].name, "carl")
        XCTAssertEqual(modelArray[0].age, 18)
        XCTAssertEqual(modelArray[1].name, "lydia")
        XCTAssertEqual(modelArray[1].age, 16)


    }
    
}

private struct Person: Codable {
    let name: String
    let age: Int
}
