//
//  NameSpaceTests.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-07.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

// `str.es`
extension String: ESNameSpace {}

// `str.es.nonEmpty`
extension ES where Base == String {
    var nonEmpty: String? { !_base.isEmpty ? _base : nil }
}

// test
final class NameSpaceTests: XCTestCase {
    
    func testNameSpace() {
        let strOrNil = "".es.nonEmpty
        XCTAssertEqual(strOrNil, nil)
    }
}
