//
//  Types.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-02-28.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// Check types of values with Generic Types

public func whether<A, B>(_ a: A, isOfTypeOf b: B) -> Bool {
    return a is B
}

public func type<A, B>(of a: A, isEqualToTypeOf b: B) -> Bool {
    return a is B && b is A
}

public func type<A, B>(of a: A, isSubclassOfTypeOf b: B) -> Bool {
    return a is B && !(b is A)
}

/// Check types of values with Any Types

public func whether(_ a: Any, isOfTypeOf b: Any) -> Bool {
    let type = Swift.type(of: b)
    var mirror: Mirror? = Mirror(reflecting: a)
    repeat {
        if mirror?.subjectType == type {
            return true
        }
        mirror = mirror?.superclassMirror
    }
    while mirror != nil
    return false
}

public func type(of a: Any, isEqualToTypeOf b: Any) -> Bool {
    return Swift.type(of: a) == Swift.type(of: b)
}

public func type(of a: Any, isSubclassOfTypeOf b: Any) -> Bool {
    return !type(of: a, isEqualToTypeOf: b) && whether(a, isOfTypeOf: b)
}

/// Check whether value/type is Optional, get Wrapped Type
/// - seealso: https://stackoverflow.com/a/32781143/456536

// !!!: MUST be `private`
private protocol OptionalProtocol {
    static var wrappedType: Any.Type { get }
    var wrappedType: Any.Type { get }
}
extension Optional: OptionalProtocol {
    static var wrappedType: Any.Type { Wrapped.self }
    var wrappedType: Any.Type { Wrapped.self }
}

public func isOptional<T>(_ type: T.Type) -> Bool {
    return type is OptionalProtocol.Type
}
public func isOptional<T>(_ value: T) -> Bool {
    return value is OptionalProtocol
}

public func wrappedType<T>(ifOptional type: T.Type) -> Any.Type? {
    return (type as? OptionalProtocol.Type)?.wrappedType
}
public func wrappedType<T>(ifOptional value: T) -> Any.Type? {
    return (value as? OptionalProtocol)?.wrappedType
}
