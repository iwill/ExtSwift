//
//  Falsify.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

struct ExtSwift {
    var text = "Hello, ExtSwift!"
}

public protocol Mutable {}
public extension Mutable {
    @discardableResult
    mutating func mutate(mutate: (inout Self) -> Void) -> Self {
        mutate(&self)
        return self
    }
    func mutating(mutate: (inout Self) -> Void) -> Self {
        var value = self
        mutate(&value)
        return value
    }
}
public extension Mutable where Self: AnyObject {
    @discardableResult
    func mutate(mutate: (Self) -> Void) -> Self {
        mutate(self)
        return self
    }
}

public func mutating<T>(_ value: T, mutate: (inout T) -> Void) -> T {
    var value = value
    mutate(&value)
    return value
}
