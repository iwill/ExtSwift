//
//  KVO.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-03-03.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// Key-Value Observing

@propertyWrapper
public class KVO<KVOType> {
    
    // MARK: property-wrapper
    
    public var projectedValue: KVO<KVOType> { self }
    
    public var wrappedValue: KVOType {
        willSet {
            let removing = observers.filter { observer in
                return observer.options.contains(.willSet) && observer.closure(newValue, wrappedValue, .willSet) == .stop
            }
            observers.removeAll { observer in
                return removing.contains { $0 === observer }
            }
        }
        didSet {
            let removing = observers.filter { observer in
                return observer.options.contains(.didSet) && observer.closure(wrappedValue, oldValue, .didSet) == .stop
            }
            observers.removeAll { observer in
                return removing.contains { $0 === observer }
            }
            if !keepEventState {
                wrappedValue = oldValue
            }
        }
    }
    
    private var keepEventState: Bool
    
    fileprivate init(wrappedValue: KVOType, keepEventState: Bool = true) {
        self.wrappedValue = wrappedValue
        self.keepEventState = keepEventState
    }
    
    public convenience init(wrappedValue: KVOType) {
        self.init(wrappedValue: wrappedValue, keepEventState: true)
    }
    
    // MARK: observers
    
    private var observers: [Observer<KVOType>] = []
    
    private final class Observer<_KVOType>: KVObserver {
        
        weak var propertyWrapper: KVO?
        let options: KVObservingOptions
        let closure: (_ newValue: _KVOType, _ oldValue: _KVOType, _ option: KVObservingOptions) -> KVObservingState
        
        init(propertyWrapper: KVO, options: KVObservingOptions, closure: @escaping (_ newValue: _KVOType, _ oldValue: _KVOType, _ option: KVObservingOptions) -> KVObservingState) {
            self.propertyWrapper = propertyWrapper
            self.options = options
            self.closure = closure
        }
        
        func isObserving() -> Bool {
            return propertyWrapper?.observers.contains { $0 === self } ?? false
        }
        
        func stopObserving() {
            propertyWrapper?.removeObserver(self)
        }
    }
    
    @discardableResult
    public func addObserver(options: KVObservingOptions = .default, using closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> KVObservingState) -> KVObserver {
        let observer = Observer(propertyWrapper: self, options: options, closure: closure)
        if !options.contains(.initial) || closure(wrappedValue, wrappedValue, .initial) == .keep {
            observers.append(observer)
        }
        return observer
    }
    
    public func keepObserver(options: KVObservingOptions = .default, using closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> Void) {
        addObserver(options: options) { newValue, oldValue, option in
            closure(newValue, oldValue, option)
            return .keep
        }
    }
    
    public func removeObserver(_ observer: KVObserver) {
        observers.removeAll { $0 === observer }
    }
}

// MARK: - event observer

@propertyWrapper
public final class EventObservable<KVOType>: KVO<KVOType> {
    
    public override var projectedValue: EventObservable<KVOType> { self }
    
    public override var wrappedValue: KVOType {
        get { return super.wrappedValue }
        set { super.wrappedValue = newValue }
    }
    
    public override init(wrappedValue: KVOType, keepEventState: Bool = false) {
        super.init(wrappedValue: wrappedValue, keepEventState: keepEventState)
    }
    
    public convenience init(wrappedValue: KVOType) {
        self.init(wrappedValue: wrappedValue, keepEventState: false)
    }
    
    @discardableResult
    public func addObserver(using closure: @escaping (_ value: KVOType) -> KVObservingState) -> KVObserver {
        return super.addObserver(options: .didSet) { value, oldValue, option -> KVObservingState in
            return closure(value)
        }
    }
    
    public func keepObserver(using closure: @escaping (_ value: KVOType) -> Void) {
        super.addObserver(options: .didSet) { value, oldValue, option -> KVObservingState in
            closure(value)
            return .keep
        }
    }
    
    @available(*, unavailable)
    public override func addObserver(options: KVObservingOptions = .default, using closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> KVObservingState) -> KVObserver {
        fatalError()
    }
    
    @available(*, unavailable)
    public override func keepObserver(options: KVObservingOptions = .default, using closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> Void) {
        fatalError()
    }
}

// MARK: -

public struct KVObservingOptions: OptionSet, CustomStringConvertible {
    
    public static let initial = KVObservingOptions(rawValue: 1 << 0) // value
    public static let willSet = KVObservingOptions(rawValue: 1 << 1) // value + oldValue
    public static let didSet  = KVObservingOptions(rawValue: 1 << 2) // value + oldValue
    
    public static let `default`: KVObservingOptions = [.initial, .didSet]
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public var description: String {
        var strings: [String] = []
        if self.contains(.initial) { strings.append("initial") }
        if self.contains(.willSet) { strings.append("willSet") }
        if self.contains(.didSet)  { strings.append("didSet") }
        return strings.joined(separator: "|")
    }
}

@objc // for mixing Swift&ObjC
public enum KVObservingState: Int { case keep = 1, stop = 0 }

// without @objc
// public enum KVObservingState { case keep, stop }

@objc // for Swift&ObjC mixed project
public protocol KVObserver: AnyObject {
    func isObserving() -> Bool
    func stopObserving()
}
