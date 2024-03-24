//
//  TypesTests.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-09.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
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
    
    func testOptional() {
        
        let some: Int???? = 1,
            optional: Int???? = Optional(Optional(Optional(Optional(nil)))),
            none: Int???? = nil
        
        print("Int.self: \(String(describing: Int.self))")
        print("Int????.self: \(String(describing: Int????.self))")
        
        print("some: \(String(describing: some))")
        print("optional: \(String(describing: optional))")
        print("none: \(String(describing: none))")
        if let some {
            print("if let some: \(String(describing: some))")
            XCTAssertEqual(some, Optional(Optional(Optional(1))))
        }
        else {
            print("else some: \(String(describing: some))")
            XCTAssertEqual(some, nil)
        }
        if let optional {
            print("if let optional: \(String(describing: optional))")
            XCTAssertEqual(optional, Optional(Optional(Optional(nil))))
        }
        else {
            print("else optional: \(String(describing: optional))")
            XCTAssertEqual(optional, nil)
        }
        if let none {
            print("if let none: \(String(describing: none))")
            XCTAssertNotEqual(none, nil)
        }
        else {
            print("else none: \(String(describing: none))")
            XCTAssertEqual(none, nil)
        }
        
        print("some.deeplyWrappedType: \(String(describing: some.deeplyWrappedType))")
        print("optional.deeplyWrappedType: \(String(describing: optional.deeplyWrappedType))")
        print("none.deeplyWrappedType: \(String(describing: none.deeplyWrappedType))")
        XCTAssert(some.deeplyWrappedType == Int.self)
        XCTAssert(optional.deeplyWrappedType == Int.self)
        XCTAssert(none.deeplyWrappedType == Int.self)
        
        print("some.deeplyWrapped!: \(String(describing: some.deeplyWrapped!))")
        print("some.deeplyWrapped: \(String(describing: some.deeplyWrapped))")
        print("optional.deeplyWrapped: \(String(describing: optional.deeplyWrapped))")
        print("none.deeplyWrapped: \(String(describing: none.deeplyWrapped))")
        XCTAssert(some.deeplyWrapped as? Int == 1)
        XCTAssert(optional.deeplyWrapped == nil)
        XCTAssert(none.deeplyWrapped == nil)
    }
}
