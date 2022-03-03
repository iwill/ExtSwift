//
//  tryIndex.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-06-19.
//  Copyright (c) 2021 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

@available(*, deprecated, message: "Suppressing warnings.")
final class tryIndexTests: XCTestCase {
    
    func testIndex() {
        
        let ints = [0, 1, 2, 3]
        
        XCTAssertEqual(ints[try: 0], 0)
        XCTAssertEqual(ints[try: 1], 1)
        XCTAssertEqual(ints[try: 4], nil)
        
        XCTAssertEqual(ints[try: -1], 3)
        XCTAssertEqual(ints[try: -2], 2)
        XCTAssertEqual(ints[try: -4], 0)
        XCTAssertEqual(ints[try: -5], nil)
        
        XCTAssertEqual(ints[try: -1...1], [0, 1])
        XCTAssertEqual(ints[try: 2...10000], [2, 3])
        XCTAssertEqual(ints[try: 4...], nil)
        
        XCTAssertEqual(ints[tryBidirectRange: 1..<bidirectIndex(from: -1)!], [1, 2]) // -> 1..<(4 - 1) -> 1..<3
        XCTAssertEqual(ints[tryBidirectRange: bidirectIndex(from: -3)!..<bidirectIndex(from: -1)!], [1, 2]) // (4 - 3)..<(4 - 1) -> 1..<3
        XCTAssertEqual(ints[tryBidirectRange: bidirectIndex(from: -6)!...bidirectIndex(from: -5)!], nil)
    }
    
    static var allTests = [
        ("testIndex", testIndex),
    ]
}
