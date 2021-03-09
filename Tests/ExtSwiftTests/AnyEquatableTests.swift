//
//  AnyEquatableTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

private struct Sa: Equatable {}
private struct Sb: Equatable {}

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

final class AnyEquatableTests: XCTestCase {
    
    // let sup = Sup()
    // let sub = Sub()
    // sup == sub // `==` from Sup
    
    // let a: Sup = Sub()
    // let b: Sup = Sub()
    // a == b // `==` from Sup instead of Sub
    
    // let sub: AnyEquatable<Sup> = AnyEquatable(sub /* as Sup */) // ok
    // let sub = AnyEquatable(sub), sub as? AnyEquatable<Sup> // always fails
    
    func testAnyEquatable() {
        let sa1 = Sa(), sa2 = Sa()
        XCTAssertTrue(sa1 == sa2)
        
        let anySa1 = AnyEquatable(sa1), anySa2 = AnyEquatable(sa2)
        XCTAssertTrue(anySa1 == anySa2)
        
        let anySb = AnyEquatable(Sb())
        XCTAssertFalse(anySb == anySa1)
        
        let sup = Sup(i: 1), sub = Sub(i: 1)
        XCTAssertTrue(sup == sub)
        
        let anySup = AnyEquatable(sup), anySub = AnyEquatable(sub/*  as Sup */)
        XCTAssertTrue(anySup == anySub)
    }
    
    static var allTests = [
        ("testAnyEquatable", testAnyEquatable),
    ]
    
}
