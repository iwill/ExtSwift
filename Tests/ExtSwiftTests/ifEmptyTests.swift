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
        
        XCTAssertEqual("x".ifEmpty(some2), "x")
        XCTAssertEqual("x".ifEmpty(none),  "x")
        XCTAssertEqual("x".ifEmpty("y"),   "x")
        XCTAssertEqual("x".nonEmptyOrNil,  "x")
        
        XCTAssertEqual("".ifEmpty(some),   some)
        XCTAssertEqual("".ifEmpty(none),   none)
        XCTAssertEqual("".ifEmpty("y"),    "y")
        XCTAssertEqual("".nonEmptyOrNil,   nil)
        
        XCTAssertEqual(some.ifEmpty("y"),  some)
        XCTAssertEqual(none.ifEmpty(some), some)
        XCTAssertEqual(some.nonEmptyOrNil, some)
        XCTAssertEqual(none.nonEmptyOrNil, nil)
    }
    
    static var allTests = [
        ("testEmpty", testEmpty),
    ]
}
