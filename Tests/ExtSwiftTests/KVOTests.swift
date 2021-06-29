//
//  KVOTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-03-03.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
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
    
    @KVO(autoResetToNil: true)
    var eventWithoutParameter: Void? = nil
    
    @KVO(autoResetToNil: true)
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
                return .goon
            }
        
        test.$s.keepObserver(options: [.initial, .willSet, .didSet]) { value, oldValue, option in
            NSLog("String - \(option): \(String(describing: oldValue)) <#->#> \(String(describing: value))")
        }
        
        let eventObserver =
        test.$eventWithoutParameter.addEventObserver { value in
            NSLog("Void: <#->#> \(String(describing: value))")
            return .goon
        }
        
        test.$eventWithIntAndString.keepEventObserver { value in
            NSLog("(Int, String): <#->#> \(String(describing: value))")
        }
        
        test.i = 1
        test.s = nil
        test.eventWithoutParameter = ()
        test.eventWithIntAndString = (1, "s")
        
        kvObserver.stopObserving()
        test.i = 2
        
        eventObserver.stopObserving()
        test.eventWithoutParameter = nil
    }
    
    static var allTests = [
        ("testObservable", testObservable),
    ]
}
