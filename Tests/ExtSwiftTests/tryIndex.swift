//
//  tryIndex.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-06-19.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

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
        XCTAssertEqual(ints[try: 2...4], [2, 3])
        XCTAssertEqual(ints[try: 4...], nil)
    }
    
    static var allTests = [
        ("testIndex", testIndex),
    ]
}
