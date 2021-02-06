//
//  NameSpaceTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

@testable
import ExtSwift

// `str.es`
extension String: ExtSwiftNameSpace {
}
// `str.es.nonEmpty`
extension NameSpace where Base == String {
    var nonEmpty: String? { return !_base.isEmpty ? _base : nil }
}

final class NameSpaceTests: XCTestCase {
    
    func testNameSpace() {
        let strOrNil = "".es.nonEmpty
        XCTAssertEqual(strOrNil, nil)
    }
    
    static var allTests = [
        ("testNameSpace", testNameSpace),
    ]
    
}
