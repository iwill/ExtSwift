//
//  Types.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-02-28.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
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
