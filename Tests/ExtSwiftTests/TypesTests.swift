//
//  TypesTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

@testable
import ExtSwift

private struct S {}

private class Sup: Equatable {
    let i: Int
    init(i: Int) {
        self.i = i
    }
    static func == (lhs: Sup, rhs: Sup) -> Bool {
        return lhs.i == rhs.i
    }
}

private class Sub: Sup {
    static func == (lhs: Sub, rhs: Sub) -> Bool {
        return lhs.i == rhs.i
    }
}

final class TypesTests: XCTestCase {
    
    func testBuiltinTypesComparing() {
        let any: Any = 1
        XCTAssertTrue(any is Int)
        
        let anyType: Any.Type = Int.self
        XCTAssertTrue(anyType == Int.self)
        XCTAssertTrue(anyType is Int.Type)
        
        let anyA: Any = 1, anyB: Any = 2
        XCTAssertTrue(whether(anyA, isOfTypeOf: anyB))
    }
    
    func testTypesComparingWithGenericTypes() {
        let s1 = S(), s2 = S()
        let sup = Sup(i: 1)
        let sub = Sub(i: 1)
        
        XCTAssertTrue(whether(s1, isOfTypeOf: s2))
        XCTAssertTrue(whether(sup, isOfTypeOf: sup))
        XCTAssertTrue(whether(sub, isOfTypeOf: sup))
        XCTAssertFalse(whether(sup, isOfTypeOf: sub))
        
        XCTAssertTrue(type(of: s1, isEqualToTypeOf: s2))
        XCTAssertTrue(type(of: sup, isEqualToTypeOf: sup))
        XCTAssertFalse(type(of: sup, isEqualToTypeOf: sub))
        XCTAssertFalse(type(of: sub, isEqualToTypeOf: sup))
        
        XCTAssertFalse(type(of: s1, isSubclassOfTypeOf: s2))
        XCTAssertFalse(type(of: sup, isSubclassOfTypeOf: sup))
        XCTAssertFalse(type(of: sup, isSubclassOfTypeOf: sub))
        XCTAssertTrue(type(of: sub, isSubclassOfTypeOf: sup))
        
        let supEqualOperator: (Sup, Sup) -> Bool = (==)
        let subEqualOperator: (Sub, Sub) -> Bool = (==)
        XCTAssertTrue(supEqualOperator(sup, sub))
        XCTAssertTrue(supEqualOperator(sub, sup))
        XCTAssertTrue(subEqualOperator(sub, Sub(i: 1)))
    }
    
    func testTypesComparingWithAnyTypes() {
        let a: Any = S(), b: Any = S()
        let sup: Any = Sup(i: 1)
        let sub: Any = Sub(i: 1)
        
        XCTAssertTrue(whether(a, isOfTypeOf: b))
        XCTAssertTrue(whether(sup, isOfTypeOf: sup))
        XCTAssertTrue(whether(sub, isOfTypeOf: sup))
        XCTAssertFalse(whether(sup, isOfTypeOf: sub))
        
        XCTAssertTrue(type(of: a, isEqualToTypeOf: b))
        XCTAssertTrue(type(of: sup, isEqualToTypeOf: sup))
        XCTAssertFalse(type(of: sup, isEqualToTypeOf: sub))
        XCTAssertFalse(type(of: sub, isEqualToTypeOf: sup))
        
        XCTAssertFalse(type(of: a, isSubclassOfTypeOf: b))
        XCTAssertFalse(type(of: sup, isSubclassOfTypeOf: sup))
        XCTAssertFalse(type(of: sup, isSubclassOfTypeOf: sub))
        XCTAssertTrue(type(of: sub, isSubclassOfTypeOf: sup))
    }
    
    static var allTests = [
        ("testBuiltinTypesComparing", testBuiltinTypesComparing),
        ("testTypesComparingWithGenericTypes", testTypesComparingWithGenericTypes),
        ("testTypesComparingWithAnyTypes", testTypesComparingWithAnyTypes),
    ]
    
}
