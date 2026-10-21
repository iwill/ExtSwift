//
//  KVOTests.swift
//  ExtSwift
//
//  Created by Míng on 2021-03-03.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

// @testable
import ExtSwift

class TestKVO {
    
    @KVO
    var i: Int
    
    @KVO
    var s: String?
    
    init(i: Int, s: String?) {
        (self.i, self.s) = (i, s)
    }
    
    @ExtKVO
    var eventWithoutParameter: Void? = nil
    
    @ExtKVO(keepEventState: true)
    var eventWithIntAndString: (i: Int, s: String)? = nil
}

// MARK: - Tests

final class KVOTests: XCTestCase {
    
    let observerAgent = ObserverAgent()
    
    func testObservable() {
        
        let test: TestKVO! = TestKVO(i: 0, s: "")
        
        XCTAssertFalse(observerAgent.isObserving())
        
        // initialValue: Value?, newValue: Value, oldValue: Value
        var i: ObservingOptions?,
            s: ObservingOptions? = nil,
            e1: ObservingOptions? = nil,
            e2: ObservingOptions? = nil
        XCTAssertEqual(i, nil)
        XCTAssertEqual(s, nil)
        XCTAssertEqual(e1, nil)
        XCTAssertEqual(e2, nil)
        
        let observer =
        test.$i.addObserver(observerAgent) { value, oldValue, option in
            NSLog("Int - \(option): \(String(describing: oldValue)) <#->#> \(value)")
            i = option
            return .keep
        }
        XCTAssertEqual(i, .initial)
        XCTAssertTrue(observerAgent.isObserving())
        
        _ = test.$s.keepObserver(observerAgent, options: [.initial, .willSet, .didSet]) { value, oldValue, option in
            NSLog("String - \(option): \(String(describing: oldValue)) <#->#> \(String(describing: value))")
            s = option
        }
        XCTAssertEqual(s, .initial)
        
        let eventObserver =
        test.$eventWithoutParameter.addObserver(observerAgent) { value in
            NSLog("Void: <#->#> \(String(describing: value))")
            e1 = .didSet
            return .keep
        }
        XCTAssertEqual(e1, nil)
        
        _ = test.$eventWithIntAndString.keepObserver(observerAgent) { value in
            NSLog("(Int, String): <#->#> \(String(describing: value))")
            e2 = .didSet
        }
        XCTAssertEqual(e2, nil)
        
        test.i = 1
        test.s = nil
        test.eventWithoutParameter = ()
        test.eventWithIntAndString = (1, "s")
        XCTAssertEqual(i, .didSet)
        XCTAssertEqual(s, .didSet)
        XCTAssertEqual(e1, .didSet)
        XCTAssertEqual(e2, .didSet)
        
        i = nil
        observer.stopObserving()
        test.i = 2
        XCTAssertEqual(i, nil)
        
        e1 = nil
        eventObserver.stopObserving() // OR `test.$eventWithoutParameter.removeObserver(eventObserver)`?
        test.eventWithoutParameter = nil
        XCTAssertEqual(e1, nil)
        
        s = nil
        e2 = nil
        observerAgent.stopObserving()
        XCTAssertFalse(observerAgent.isObserving())
        test.s = nil
        test.eventWithIntAndString = (1, "s")
        XCTAssertEqual(s, nil)
        XCTAssertEqual(e2, nil)
    }
}
