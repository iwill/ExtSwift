//
//  Mutable.swift
//  ExtSwift
//
//  Created by Míng on 2021-06-10.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// MARK: value-type

/// - seealso: [solution](https://stackoverflow.com/a/42356615/456536)
/// - seealso: [issue](https://bugs.swift.org/browse/SR-10121)
/// - seealso: [pr](https://github.com/apple/swift/pull/23430)
public protocol Mutable {}
public extension Mutable {
    @discardableResult
    mutating func mutate(_ mutate: (inout Self) -> Void) -> Self {
        mutate(&self)
        return self
    }
    func mutating(_ mutate: (inout Self) -> Void) -> Self {
        var value = self
        mutate(&value)
        return value
    }
}

// not suggested for reference-type
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

extension Optional: Mutable where Wrapped: Mutable {
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

public extension Mutable where Self: AnyObject {
    func mutating(_ mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

extension Optional where Wrapped: Mutable {
    func mutating(_ mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

public func mutating<T: AnyObject>(_ value: T, _ mutate: (inout T) -> Void) -> T {
    var value = value
    mutate(&value)
    return value
}

public func mutating<T: AnyObject>(_ value: T?, _ mutate: (inout T?) -> Void) -> T? {
    var value = value
    mutate(&value)
    return value
}
