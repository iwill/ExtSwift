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
            optionalSome: Int???? = Optional(Optional(Optional(Optional(1)))),
            optionalNone: Int???? = Optional(Optional(Optional(Optional(nil)))),
            none: Int???? = nil
        
        print("Int.self: \(String(describing: Int.self))")
        print("Int????.self: \(String(describing: Int????.self))")
        
        print("some: \(String(describing: some))")
        print("optionalSome: \(String(describing: optionalSome))")
        print("optionalNone: \(String(describing: optionalNone))")
        print("none: \(String(describing: none))")
        
        if let some {
            print("if let some: \(String(describing: some))")
            XCTAssertEqual(some, Optional(Optional(Optional(1))))
        }
        else {
            // print("else some: \(String(describing: some))")
            // XCTAssertEqual(some, nil)
            XCTFail()
        }
        
        if let optionalSome {
            print("if let optionalSome: \(String(describing: optionalSome))")
            XCTAssertEqual(optionalSome, Optional(Optional(Optional(1))))
        }
        else {
            // print("else optionalSome: \(String(describing: optionalSome))")
            // XCTAssertEqual(optionalSome, nil)
            XCTFail()
        }
        
        if let optionalNone {
            print("if let optionalNone: \(String(describing: optionalNone))")
            XCTAssertEqual(optionalNone, Optional(Optional(Optional(nil))))
            XCTAssertNotEqual(optionalNone, nil)
        }
        else {
            // print("else optionalNone: \(String(describing: optionalNone))")
            // XCTAssertEqual(optionalNone, nil)
            XCTFail()
        }
        
        if let _ = none {
            // print("if let none: \(String(describing: none))")
            // XCTAssertNotEqual(none, nil)
            XCTFail()
        }
        else {
            print("else none: \(String(describing: none))")
            XCTAssertEqual(none, nil)
        }
        
        print("some.wrappedType: \(String(describing: some.wrappedType))")
        print("optionalSome.wrappedType: \(String(describing: optionalSome.wrappedType))")
        print("optionalNone.wrappedType: \(String(describing: optionalNone.wrappedType))")
        print("none.wrappedType: \(String(describing: none.wrappedType))")
        XCTAssert(some.wrappedType == Int.self)
        XCTAssert(optionalSome.wrappedType == Int.self)
        XCTAssert(optionalNone.wrappedType == Int.self)
        XCTAssert(none.wrappedType == Int.self)
        
        print("some.wrapped: \(String(describing: some.wrapped))")
        print("some.wrapped!: \(String(describing: some.wrapped!))")
        
        print("optionalSome.wrapped: \(String(describing: optionalSome.wrapped))")
        print("optionalSome.wrapped!: \(String(describing: optionalSome.wrapped!))")
        
        print("optionalNone.wrapped: \(String(describing: optionalNone.wrapped))")
        print("none.wrapped: \(String(describing: none.wrapped))")
        
        XCTAssert(some.wrapped as? Int == 1)
        XCTAssert(optionalSome.wrapped as? Int == 1)
        XCTAssert(optionalNone.wrapped == nil)
        XCTAssert(none.wrapped == nil)
    }
}
