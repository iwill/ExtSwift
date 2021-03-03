//
//  KVO.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-03-03.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// KVO: KeyPath-Value Observing

// MARK: - Observable

typealias KVO = Observable

protocol Observable: Observed {
    associatedtype Target = Self where Target: Observable
    
    var observations: [Observation<Target>] { get set }
    
    @discardableResult
    func kvo<Value>(keyPath: KeyPath<Target, Value>, options: ObservingOptions, closure: @escaping ObservingClosure<Target>) -> Observation<Target>
    
    func remove(observation: Observation<Target>)
    func removeAll(where shouldBeRemoved: (PartialKeyPath<Target>, ObservingOptions, AnyObject?) -> Bool)
    // func removeAll()
    
    func set<Value>(_ value: Value, for keyPath: ReferenceWritableKeyPath<Target, Value>)
    subscript<Value>(set keyPath: ReferenceWritableKeyPath<Target, Value>) -> Value { get set }
    
    func willSet<Value>(_ value: Value, _ oldValue: Value?, for keyPath: KeyPath<Target, Value>)
    func didSet<Value>(_ value: Value, _ oldValue: Value?, for keyPath: KeyPath<Target, Value>)
    
}

// MARK: Observable - default implementation

extension Observable where Target == Self {
    
    @discardableResult
    func kvo<Value>(keyPath: KeyPath<Target, Value>, options: ObservingOptions = .default, closure: @escaping ObservingClosure<Target>) -> Observation<Target> {
        let observation = Observation(target: self, keyPath: keyPath, options: options, closure: closure)
        var state = ObservingState.goon
        if options.contains(.initial) {
            let change = ObservingChange<Target, Any>(value: self[keyPath: keyPath], oldValue: nil, target: self, keyPath: keyPath, option: .initial)
            state = closure(change.value, change.oldValue, change)
        }
        if state == .goon {
            observations.append(observation)
        }
        return observation
    }
    
    func remove(observation: Observation<Target>) {
        let owners = observations.filter { $0 === observation && $0.owner != nil }.map { $0.owner! }
        observations.removeAll { $0 === observation || $0.ownerLost == true }
        removeSelf(from: owners)
    }
    
    func removeAll(where shouldBeRemoved: (PartialKeyPath<Target>, ObservingOptions, AnyObject?) -> Bool) {
        var owners = [AnyObject]()
        observations.removeAll {
            let remove = shouldBeRemoved($0.keyPath, $0.options, $0.owner)
            if remove && $0.owner != nil {
                owners.append($0.owner!)
            }
            return remove
        }
        removeSelf(from: owners)
    }
    
    func removeAll() {
        observations.removeAll()
    }
    
    private func removeSelf(from owners: [AnyObject]) {
        let owners = owners.filter { owner in
            for observation in observations {
                if observation.owner === owner {
                    return false
                }
            }
            return true
        }
        owners.forEach {
            if let owner = $0 as? Observer {
                owner.stopObserving(target: self)
            }
        }
    }
    
    func set<Value>(_ value: Value, for keyPath: ReferenceWritableKeyPath<Target, Value>) {
        let oldValue = self[keyPath: keyPath]
        willSet(value, oldValue, for: keyPath)
        self[keyPath: keyPath] = value
        didSet(value, oldValue, for: keyPath)
    }
    
    subscript<Value>(set keyPath: ReferenceWritableKeyPath<Target, Value>) -> Value {
        get { return self[keyPath: keyPath] }
        set { self.set(newValue, for: keyPath) }
    }
    
    func willSet<Value>(_ value: Value, _ oldValue: Value?, for keyPath: KeyPath<Target, Value>) {
        observations.forEach { observation in
            if observation.ownerLost == true {
                remove(observation: observation)
            }
            else if observation.keyPath == keyPath && observation.options.contains(.willSet) {
                let change = ObservingChange<Target, Any>(value: value, oldValue: oldValue, target: self, keyPath: keyPath, option: .willSet)
                let state = observation.closure(change.value, change.oldValue, change)
                if state == .stop {
                    remove(observation: observation)
                }
            }
        }
    }
    
    func didSet<Value>(_ value: Value, _ oldValue: Value?, for keyPath: KeyPath<Target, Value>) {
        observations.forEach { observation in
            if observation.ownerLost == true {
                remove(observation: observation)
            }
            else if observation.keyPath == keyPath && observation.options.contains(.didSet) {
                let change = ObservingChange<Target, Any>(value: value, oldValue: oldValue, target: self, keyPath: keyPath, option: .didSet)
                let state = observation.closure(change.value, change.oldValue, change)
                if state == .stop {
                    remove(observation: observation)
                }
            }
        }
    }
    
}

// MARK: Observable - events extension

extension Observable where Target == Self {
    @discardableResult
    func observeEvent<Value>(with keyPath: KeyPath<Target, Value>, closure: @escaping ObservingClosure<Target>) -> Observation<Target> {
        return kvo(keyPath: keyPath, options: .didSet, closure: closure)
    }
    func triggerEvent<Value>(with keyPath: KeyPath<Target, Value>, value: Value) {
        didSet(value, nil, for: keyPath)
    }
}

// MARK: - Observer

protocol Observer: AnyObject {
    var observedTargets: WeakArray<AnyObject> { get set }
    func kvo<Target: Observable, Value>(to target: Target, keyPath: KeyPath<Target, Value>, options: ObservingOptions, closure: @escaping ObservingClosure<Target>) -> Observation<Target> where Target == Target.Target
    func stopObserving<Target: Observable>(target: Target)
    func stopAllObserving()
}

// MARK: Observer - default implementation

extension Observer {
    @discardableResult
    func kvo<Target: Observable, Value>(to target: Target, keyPath: KeyPath<Target, Value>, options: ObservingOptions = .default, closure: @escaping ObservingClosure<Target>) -> Observation<Target> where Target == Target.Target {
        let observation = target.kvo(keyPath: keyPath, options: options, closure: closure)
        observation.owner = self
        observedTargets.append(WeakBox(target))
        return observation
    }
    func stopObserving<Target: Observable>(target: Target) {
        observedTargets.forEach {
            if $0.wrapped === target { ($0.wrapped as! Observed).remove(observer: self) }
        }
        observedTargets.removeAll { $0.wrapped === target }
    }
    func stopAllObserving() {
        observedTargets.forEach { ($0.wrapped as! Observed).remove(observer: self) }
        observedTargets.removeAll()
    }
}

// MARK: - 

// MARK: Options

struct ObservingOptions: OptionSet, CustomStringConvertible {
    let rawValue: Int
    static let initial = ObservingOptions(rawValue: 1 << 0) // value
    static let willSet = ObservingOptions(rawValue: 1 << 1) // value + oldValue
    static let didSet  = ObservingOptions(rawValue: 1 << 2) // value + oldValue
    static let `default`: ObservingOptions = [.initial, .didSet]
    var description: String {
        var strings: [String] = []
        if self.contains(.initial) { strings.append("initial") }
        if self.contains(.willSet) { strings.append("willSet") }
        if self.contains(.didSet)  { strings.append("didSet") }
        return strings.joined(separator: "|")
    }
}

// MARK: Change

struct ObservingChange<Target, Value> {
    let value: Value
    let oldValue: Value?
    let target: Target
    let keyPath: PartialKeyPath<Target>
    let option: ObservingOptions
}

extension ObservingChange where Value: Equatable {
    var notEqual: Bool {
        return value != oldValue
    }
}

extension ObservingChange where Value: AnyObject {
    var notIdentical: Bool {
        return value !== oldValue
    }
}

// MARK: State & Closure

enum ObservingState { case goon, stop }
typealias ObservingClosure<Target> = (Any, Any?, ObservingChange<Target, Any>) -> ObservingState

// MARK: Observation

class Observation<Target: AnyObject> {
    fileprivate private(set) weak var target: Target?
    fileprivate let keyPath: PartialKeyPath<Target>
    fileprivate let options: ObservingOptions
    fileprivate let closure: ObservingClosure<Target>
    fileprivate init(target: Target, keyPath: PartialKeyPath<Target>, options: ObservingOptions = [], closure: @escaping ObservingClosure<Target>) {
        (self.target, self.keyPath, self.options, self.closure)
            = (target, keyPath, options, closure)
    }
    fileprivate private(set) var ownerLost: Bool? = nil
    fileprivate weak var owner: AnyObject? {
        didSet { ownerLost = (owner == nil) }
    }
}

extension Observation where Target: Observable {
    func isObserving() -> Bool {
        return target?.observations.contains { $0 === self } ?? false
    }
    func stopObserving() where Target == Target.Target {
        target?.remove(observation: self)
    }
}

// MARK: Observed

protocol Observed: AnyObject {
    func remove(observer: AnyObject)
}

extension Observed where Self: Observable {
    func remove(observer: AnyObject) {
        observations.removeAll { $0.owner === observer || $0.ownerLost == true }
    }
}
