//
//  Mutable.swift
//  ExtSwift
//
//  Created by Míng on 2021-06-10.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// - seealso: [solution](https://stackoverflow.com/a/42356615/456536)
/// - seealso: [issue](https://bugs.swift.org/browse/SR-10121)
/// - seealso: [pr](https://github.com/apple/swift/pull/23430)
public protocol Mutable {}
public extension Mutable {
    // mutate self, returning self for chaining
    @discardableResult
    mutating func mutate(_ mutate: (inout Self) -> Void) -> Self {
        mutate(&self)
        return self
    }
    // mutating an immutable value and returning a new one
    func mutating(_ mutate: (inout Self) -> Void) -> Self {
        var value = self
        mutate(&value)
        return value
    }
}

extension Optional: Mutable where Wrapped: Mutable {
    @discardableResult
    func mutate(_ mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

// MARK: value-type

// not recommended for reference-type
public func mutating<T>(_ value: T, _ mutate: (inout T) -> Void) -> T {
    var value = value
    mutate(&value)
    return value
}

// MARK: reference-type

public extension Mutable where Self: AnyObject {
    @discardableResult
    func mutate(_ mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

// requires type `T` be a class type
public func mutate<T: AnyObject>(_ value: T, _ mutate: (T) -> Void) -> T {
    mutate(value)
    return value
}
// for optional type `T?`
public func mutate<T: AnyObject>(_ value: T?, _ mutate: (T?) -> Void) -> T? {
    mutate(value)
    return value
}

// MARK: for reference-type
// MARK: deprecated - prevent value-type methods being used for reference-type

public extension Mutable where Self: AnyObject {
    @available(*, deprecated, message: "Use `mutate(_:)` instead.")
    func mutating(_ mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

extension Optional where Wrapped: Mutable {
    @available(*, deprecated, message: "Use `mutate(_:)` instead.")
    func mutating(_ mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

@available(*, deprecated, message: "Use `mutate(_:mutate:)` instead.")
public func mutating<T: AnyObject>(_ value: T, _ mutate: (inout T) -> Void) -> T {
    var value = value
    mutate(&value)
    return value
}

@available(*, deprecated, message: "Use `mutate(_:mutate:)` instead.")
public func mutating<T: AnyObject>(_ value: T?, _ mutate: (inout T?) -> Void) -> T? {
    var value = value
    mutate(&value)
    return value
}
