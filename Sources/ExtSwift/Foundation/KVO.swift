//
//  KVO.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-03-03.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// KVO: Key-Value Observing

@propertyWrapper
public final class KVO<KVOType> {
    
    private var observers: [Observer<KVOType>] = []
    
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
            if autoResetToNil {
                wrappedValue = oldValue
            }
        }
    }
    
    private var autoResetToNil: Bool
    
    public init(wrappedValue: KVOType, autoResetToNil: Bool = false) {
        self.wrappedValue = wrappedValue
        self.autoResetToNil = autoResetToNil
    }
}

// MARK: - KVObserver

public protocol KVObserver: AnyObject {
    func isObserving() -> Bool
    func stopObserving()
}

extension KVO {
    
    private final class Observer<KVOType>: KVObserver {
        
        weak var propertyWrapper: KVO?
        let options: KVObservingOptions
        let closure: (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> KVObservingState
        
        init(propertyWrapper: KVO, options: KVObservingOptions, closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> KVObservingState) {
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
    
    public func addObserver(options: KVObservingOptions = .default, using closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> KVObservingState) -> some KVObserver {
        let observer = Observer(propertyWrapper: self, options: options, closure: closure)
        if !options.contains(.initial) || closure(wrappedValue, wrappedValue, .initial) == .goon {
            observers.append(observer)
        }
        return observer
    }
    
    public func removeObserver(_ observer: KVObserver) {
        observers.removeAll { $0 === observer }
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

public enum KVObservingState { case goon, stop }

// MARK: - events extension

public extension KVO {
    
    func keepObserver(options: KVObservingOptions = .default, using closure: @escaping (_ newValue: KVOType, _ oldValue: KVOType, _ option: KVObservingOptions) -> Void) {
        _ = addObserver(options: options) { newValue, oldValue, option in
            closure(newValue, oldValue, option)
            return .goon
        }
    }
    
    func addEventObserver(using closure: @escaping (_ value: KVOType) -> KVObservingState) -> some KVObserver {
        return addObserver(options: .didSet) { value, oldValue, option -> KVObservingState in
            return closure(value)
        }
    }
    
    func keepEventObserver(using closure: @escaping (_ value: KVOType) -> Void) {
        _ = addObserver(options: .didSet) { value, oldValue, option -> KVObservingState in
            closure(value)
            return .goon
        }
    }
}
