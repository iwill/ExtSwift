//
//  ExtSwiftTests.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-01-09.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

@testable
import ExtSwift

struct Test: Mutable {
    var i: Int
}

final class ExtSwiftTests: XCTestCase {
    
    func testMutable() {
        var test = Test(i: 0).mutating { t in
            t.i = 1
        }
        XCTAssertEqual(test.i, 1)
        test.mutate { t in
            t.i = 2
        }
        XCTAssertEqual(test.i, 2)
    }
    
    func testExtSwift() {
        XCTAssertEqual(ExtSwift().text, "Hello, ExtSwift!")
    }
    
    static var allTests = [
        ("testMutable", testMutable),
        ("testExtSwift", testExtSwift),
    ]
}
