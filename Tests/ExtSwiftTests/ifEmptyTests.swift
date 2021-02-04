//
//  ifEmptyTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest
@testable import ExtSwift

final class ifEmptyTests: XCTestCase {
    
    func testEmpty() {
        
        let some: String? = "x", some2: String? = "y", none: String? = nil
        
        XCTAssertEqual("x".ifEmpty(some2), "x")
        XCTAssertEqual("x".ifEmpty(none),  "x")
        XCTAssertEqual("x".ifEmpty("y"),   "x")
        XCTAssertEqual("x".nilIfEmpty,     "x")
        
        XCTAssertEqual("".ifEmpty(some),   some)
        XCTAssertEqual("".ifEmpty(none),   none)
        XCTAssertEqual("".ifEmpty("y"),    "y")
        XCTAssertEqual("".nilIfEmpty,      nil)
        
        XCTAssertEqual(some.ifEmpty("y"),  some)
        XCTAssertEqual(none.ifEmpty(some), some)
        XCTAssertEqual(some.nilIfEmpty,    some)
        XCTAssertEqual(none.nilIfEmpty,    nil)
        
    }
    
    static var allTests = [
        ("testEmpty", testEmpty),
    ]
}
