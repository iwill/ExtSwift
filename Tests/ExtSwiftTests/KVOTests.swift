//
//  KVOTests.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-03-03.
//  Copyright (c) 2021 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
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
    
    @EventObservable
    var eventWithoutParameter: Void? = nil
    
    @EventObservable(keepEventState: true)
    var eventWithIntAndString: (i: Int, s: String)? = nil
}

// MARK: - Tests

final class KVOTests: XCTestCase {
    
    func testObservable() {
        
        let test: TestKVO! = TestKVO(i: 0, s: "")
        
        // initialValue: Value?, newValue: Value, oldValue: Value
        
        let kvObserver =
            test.$i.addObserver { value, oldValue, option in
                NSLog("Int - \(option): \(String(describing: oldValue)) <#->#> \(value)")
                return .keep
            }
        
        test.$s.keepObserver(options: [.initial, .willSet, .didSet]) { value, oldValue, option in
            NSLog("String - \(option): \(String(describing: oldValue)) <#->#> \(String(describing: value))")
        }
        
        let eventObserver =
        test.$eventWithoutParameter.addObserver { value in
            NSLog("Void: <#->#> \(String(describing: value))")
            return .keep
        }
        
        test.$eventWithIntAndString.keepObserver { value in
            NSLog("(Int, String): <#->#> \(String(describing: value))")
        }
        
        test.i = 1
        test.s = nil
        test.eventWithoutParameter = ()
        test.eventWithIntAndString = (1, "s")
        
        kvObserver.stopObserving()
        test.i = 2
        
        eventObserver.stopObserving() // OR `test.$eventWithoutParameter.removeObserver(eventObserver)`
        test.eventWithoutParameter = nil
    }
    
    static var allTests = [
        ("testObservable", testObservable),
    ]
}
