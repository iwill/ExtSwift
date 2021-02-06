//
//  FalsifyTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

@testable
import ExtSwift

final class FalsifyTests: XCTestCase {
    
    func testFalsify() {
        
        let some: String? = "x", none: String? = nil
        
        XCTAssertTrue(true.isFalsy  == false)
        XCTAssertTrue(false.isFalsy == true)
        XCTAssertTrue(1.isFalsy     == false)
        XCTAssertTrue(0.isFalsy     == true)
        XCTAssertTrue(1.0.isFalsy   == false)
        XCTAssertTrue(0.0.isFalsy   == true)
        
        XCTAssertTrue(true.isFalsy  == !true.isTruthy)
        XCTAssertTrue(false.isFalsy == !false.isTruthy)
        XCTAssertTrue(1.isFalsy     == !1.isTruthy)
        XCTAssertTrue(0.isFalsy     == !0.isTruthy)
        XCTAssertTrue(1.0.isFalsy   == !1.0.isTruthy)
        XCTAssertTrue(0.0.isFalsy   == !0.0.isTruthy)
        
        XCTAssertTrue(some.isFalsy  == false)
        XCTAssertTrue(some.isTruthy == true)
        XCTAssertTrue(none.isFalsy  == true)
        XCTAssertTrue(none.isTruthy == false)
        
        XCTAssertTrue(some.isFalsy  == !some.isTruthy)
        XCTAssertTrue(none.isFalsy  == !none.isTruthy)
        
    }
    
    static var allTests = [
        ("testFalsify", testFalsify),
    ]
    
}
