//
//  ExtSwiftTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

@testable
import ExtSwift

final class ExtSwiftTests: XCTestCase {
    
    func testExtSwift() {
        XCTAssertEqual(ExtSwift().text, "Hello, ExtSwift!")
    }
    
    static var allTests = [
        ("testExtSwift", testExtSwift),
    ]
    
}
