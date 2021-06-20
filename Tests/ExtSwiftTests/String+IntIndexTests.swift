//
//  String+IntIndexTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-03-19.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

final class IntIndexTests: XCTestCase {
    
    func testIntIndex() {
        
        let fingers = "👌🏿👍🏿🤞🏿🤟🏿"
        
        // Int to String.Index
        let index = fingers.index(from: 3)
        XCTAssertEqual(index, fingers.index(before: fingers.endIndex))
        // String.Index to Int
        let intIndex = fingers.intIndex(from: fingers.endIndex)
        XCTAssertEqual(intIndex, 4)
        
        // String at Index
        let three = fingers[3]
        XCTAssertEqual(three, "🤟🏿")
        
        // Range<Int>
        let eq1_lt3 = fingers[1..<3]
        XCTAssertEqual(eq1_lt3, "👍🏿🤞🏿")
        let eq1lt4 = fingers[1..<4]
        XCTAssertEqual(eq1lt4, "👍🏿🤞🏿🤟🏿")
        
        // ClosedRange<Int>
        let eq1_eq2 = fingers[1...2]
        XCTAssertEqual(eq1_eq2, "👍🏿🤞🏿")
        let eq1_eq3 = fingers[1...3]
        XCTAssertEqual(eq1_eq3, "👍🏿🤞🏿🤟🏿")
        
        // PartialRangeUpTo<Int>
        let _lt1 = fingers[..<1]
        XCTAssertEqual(_lt1, "👌🏿")
        // PartialRangeThrough<Int>
        let _eq1 = fingers[...1]
        XCTAssertEqual(_eq1, "👌🏿👍🏿")
        // PartialRangeFrom<Int>
        let eq2_ = fingers[2...]
        XCTAssertEqual(eq2_, "🤞🏿🤟🏿")
        
        // runtime error
        // XCTAssertThrowsError(fingers[5])
        // XCTAssertThrowsError(fingers[1..<5])
        // XCTAssertThrowsError(fingers[1...5])
    }
    
    static var allTests = [
        ("testIntIndex", testIntIndex),
    ]
}
