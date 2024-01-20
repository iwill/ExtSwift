//
//  ExtSwiftTests.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-09.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest
@testable import ExtSwift

import JavaScriptCore

struct Test: Mutable {
    var i: Int
}

@objc
class TestObject: NSObject, Mutable {
    @objc var i: Int
    init(i: Int) {
        self.i = i
    }
    func key() -> String {
        return #keyPath(i)
    }
}

final class ExtSwiftTests: XCTestCase {
    
    func testExtSwift() {
        XCTAssertEqual(ExtSwift().text, "Hello, ExtSwift!")
    }
    
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
    
    func testKeyPath() {
        let t = TestObject(i: 1)
        XCTAssertEqual(t.key(), "i")
    }
    
    func testJSCore() {
        self.measure {
            var arr = [JSContext]()
            for _ in 0..<1000 {
                let cxt = JSContext()!
                cxt.evaluateScript("""
                    req = {
                        funcs = {};
                        vars  = {};
                        vals  = [];
                    };
                    """)
                arr.append(cxt)
            }
            XCTAssertEqual(arr.count, 1000)
        }
    }
}
