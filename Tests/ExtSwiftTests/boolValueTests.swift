//
//  boolValueTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

final class BoolValueTests: XCTestCase {
    
    func testBoolValue() {
        
        let some: String? = "x", none: String? = nil
        
        XCTAssertTrue(true.boolValue  == true)
        XCTAssertTrue(false.boolValue == false)
        XCTAssertTrue(1.boolValue     == true)
        XCTAssertTrue(0.boolValue     == false)
        XCTAssertTrue(1.0.boolValue   == true)
        XCTAssertTrue(0.0.boolValue   == false)
        
#if canImport(CoreGraphics)
        XCTAssertTrue((0.1 as CGFloat).boolValue == true)
        XCTAssertTrue((0.0 as CGFloat).boolValue == false)
#endif
        
        XCTAssertTrue(some.boolValue  == true)
        XCTAssertTrue(none.boolValue  == false)
    }
    
    static var allTests = [
        ("testBoolValue", testBoolValue),
    ]
}
