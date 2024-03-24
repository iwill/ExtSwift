//
//  Types.swift
//  ExtSwift
//
//  Created by Míng on 2021-02-28.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
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
/// - seealso: https://forums.swift.org/t/challenge-finding-base-type-of-nested-optionals/25096/2
/// - seealso: https://stackoverflow.com/a/32781143/456536

// !!!: MUST be `fileprivate`
fileprivate protocol OptionalProtocol {
    static var deeplyWrappedType: Any.Type { get }
    var deeplyWrappedType: Any.Type { get }
    var deeplyWrapped: Any? { get }
}

extension Optional: OptionalProtocol {
    
    fileprivate static var deeplyWrappedType: Any.Type {
        return switch Wrapped.self {
            case let optional as OptionalProtocol.Type:
                optional.deeplyWrappedType
            default:
                Wrapped.self
        }
    }
    public var deeplyWrappedType: Any.Type {
        return switch self {
            case .some(let optional as OptionalProtocol):
                optional.deeplyWrappedType
            case .some(let wrapped):
                type(of: wrapped)
            case .none:
                Optional.deeplyWrappedType
        }
    }
    
    public var deeplyWrapped: Any? {
        guard case let .some(wrapped) = self else { return nil }
        guard let wrapped = wrapped as? OptionalProtocol else { return wrapped }
        return wrapped.deeplyWrapped
    }
}
