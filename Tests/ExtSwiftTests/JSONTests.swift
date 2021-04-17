//
//  JSONTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-03-15.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

final class JSONTests: XCTestCase {
    
    func testJSON() {
        
        let data = Data("""
        {
            "i": 1,
            "d": 1.23,
            "b": true,
            "s": "4.56",
            "a": [1, 1.23, true, "4.56"],
            "o": {"a": 1, "b": 2}
        }
        """.utf8)
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        ({
            let i = json["i", as: Int.self]
            XCTAssertEqual(i, 1)
            let d = json["i", as: Double.self]
            XCTAssertEqual(d, 1.0)
            let b = json["i", as: Bool.self]
            XCTAssertEqual(b, true)
            let s = json["i", as: String.self]
            XCTAssertEqual(s, "1")
        }())
        
        ({
            let i = json["d", as: Int.self]
            XCTAssertEqual(i, 1)
            let d = json["d", as: Double.self]
            XCTAssertEqual(d, 1.23)
            let b = json["d", as: Bool.self]
            XCTAssertEqual(b, true)
            let s = json["d", as: String.self]
            XCTAssertEqual(s, "1.23")
        }())
        
        ({
            let i = json["b", as: Int.self]
            XCTAssertEqual(i, 1)
            let d = json["b", as: Double.self]
            XCTAssertEqual(d, 1.0)
            let b = json["b", as: Bool.self]
            XCTAssertEqual(b, true)
            let s = json["b", as: String.self]
            XCTAssertEqual(s, "1")
        }())
        
        ({
            let i = json["s", as: Int.self]
            XCTAssertEqual(i, 4)
            let d = json["s", as: Double.self]
            XCTAssertEqual(d, 4.56)
            let b = json["s", as: Bool.self]
            XCTAssertEqual(b, true)
            let s = json["s", as: String.self]
            XCTAssertEqual(s, "4.56")
        }())
        
        ({
            let a = json["a", as: [Any].self]!
            XCTAssertEqual(try! JSONSerialization.data(withJSONObject: a),
                           try! JSONSerialization.data(withJSONObject: [1, 1.23, true, "4.56"]))
            let i = a[0, as: Int.self]
            XCTAssertEqual(i, 1)
            let d = a[1, as: Double.self]
            XCTAssertEqual(d, 1.23)
            let b = a[2, as: Bool.self]
            XCTAssertEqual(b, true)
            let s = a[3, as: String.self]
            XCTAssertEqual(s, "4.56")
        }())
        
        ({
            let o = json["o", as: [String: Any].self]
            XCTAssertEqual(o as! [String: Int], ["a": 1, "b": 2])
        }())
        
    }
    
    static var allTests = [
        ("testJSON", testJSON),
    ]
    
}
