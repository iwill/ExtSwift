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

// MARK: value-type

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

public func mutate<T: AnyObject>(_ value: T, _ mutate: (T) -> Void) -> T {
    mutate(value)
    return value
}

// MARK: deprecated - prevent value-type methods being used for reference-type

public extension Mutable where Self: AnyObject {
    @available(*, deprecated, message: "This method is only used for value type!")
    mutating func mutate(_ mutate: (inout Self) -> Void) -> Self {
        fatalError("This method is only used for value type!")
    }
    @available(*, deprecated, message: "This method is only used for value type!")
    func mutating(_ mutate: (inout Self) -> Void) -> Self {
        fatalError("This method is only used for value type!")
    }
}

@available(*, deprecated, message: "This method is only used for value type!")
public func mutating<T: AnyObject>(_ value: T, _ mutate: (inout T) -> Void) -> T {
    fatalError("This method is only used for value type!")
}
