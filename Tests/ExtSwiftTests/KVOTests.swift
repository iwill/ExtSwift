//
//  KVOTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-03-03.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

@testable
import ExtSwift

class AnObserver: Observer {
    var observedTargets: WeakArray<AnyObject> = []
}

class TestObservable: Observable {
    
    var observations: [Observation<TestObservable>] = []
    
    var i: Int
    var s: String?
    init(i: Int, s: String?) {
        (self.i, self.s) = (i, s)
    }
    
    let eventWithoutParameter: Void? = nil //  { get { return nil } set {} }
    let eventWithIntAndString: (Int, String)? = nil //  { get { return nil } set {} }
    
}

// MARK: - Tests

final class KVOTests: XCTestCase {
    
    func testObservable() {
        var test: TestObservable! = TestObservable(i: 0, s: "")
        
        // initialValue: Value?, newValue: Value, oldValue: Value
        
        let observation =
        test.kvo(keyPath: \.i) { [weak self] (value, oldValue, change) -> ObservingState in
            guard self != nil else { return .stop }
            let value = value as! Int
            let oldValue = oldValue as? Int
            debugPrint("[\(#function):\(#line)] Int - \(change.option): \(String(describing: oldValue)) <#->#> \(value)")
            return .goon
        }
        test.kvo(keyPath: \.s, options: [.initial, .willSet, .didSet]) { [weak self] (value, oldValue, change) -> ObservingState in
            guard self != nil else { return .stop }
            let value = value as? String
            let oldValue = oldValue as? String
            debugPrint("[\(#function):\(#line)] String - \(change.option): \(String(describing: oldValue)) <#->#> \(String(describing: value))")
            return .goon
        }
        
        test.observeEvent(with: \.eventWithoutParameter) { [weak self] (value, change) -> ObservingState in
            guard self != nil else { return .stop }
            let value: Void = value as! Void
            debugPrint("[\(#function):\(#line)] <none> - \(change.option): <#->#> \(String(describing: value))")
            return .goon
        }
        test.observeEvent(with: \.eventWithIntAndString) { [weak self] (value, change) -> ObservingState in
            guard self != nil else { return .stop }
            let value = value as! (Int, String)
            debugPrint("[\(#function):\(#line)] (Int, String) - \(change.option): <#->#> \(String(describing: value))")
            return .goon
        }
        
        // test.set(1, for: \.i)
        // test.set(nil, for: \.s)
        test[set: \.i] = 1
        test[set: \.s] = nil
        test.triggerEvent(with: \.eventWithoutParameter, value: ())
        test.triggerEvent(with: \.eventWithIntAndString, value: (1, "s"))
        
        observation.stopObserving()
        let observer = AnObserver()
        observer.kvo(to: test, keyPath: \.i) { (value, oldValue, change) -> ObservingState in
            let value = value as! Int
            let oldValue = oldValue as? Int
            debugPrint("kvo: [\(#function):\(#line)] Int - \(change.option): \(String(describing: oldValue)) <#->#> \(String(describing: value))")
            return .goon
        }
        test[set: \.i] = 2
        test[set: \.i] = 3
        // observer.stopObserving(target: test)
        test[set: \.i] = 4
        
        test = nil
        observer.observedTargets.compact()
        debugPrint("targets: \(String(describing: observer.observedTargets.count))")
        
    }
    
    static var allTests = [
        ("testObservable", testObservable),
    ]
    
}
