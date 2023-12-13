//
//  ifEmptyTests.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-01-07.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

final class ifEmptyTests: XCTestCase {
    
    func testEmpty() {
        
        let some: String? = "x", some2: String? = "y", none: String? = nil
        
        XCTAssertEqual("x".nonEmpty ?? some2,   "x")
        XCTAssertEqual("x".nonEmpty ?? none,    "x")
        XCTAssertEqual("x".nonEmpty ?? "y",     "x")
        XCTAssertEqual("x".nonEmpty,            "x")
        
        XCTAssertEqual("".nonEmpty ?? some,     some)
        XCTAssertEqual("".nonEmpty ?? none,     none)
        XCTAssertEqual("".nonEmpty ?? "y",      "y")
        XCTAssertEqual("".nonEmpty,             nil)
        
        XCTAssertEqual(some.nonEmpty ?? "y",    some)
        XCTAssertEqual(none.nonEmpty ?? some,   some)
        XCTAssertEqual(some.nonEmpty,           some)
        XCTAssertEqual(none.nonEmpty,           nil)
    }
    
    static var allTests = [
        ("testEmpty", testEmpty),
    ]
}
