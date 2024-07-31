//
//  Optional+opt.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-20.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension Optional {
    func transform<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U? {
        guard case let .some(wrapped) = self else { return nil }
        return try transform(wrapped)
    }
}

/// Check whether value/type is Optional, get wrapped value/type
/// - seealso: https://forums.swift.org/t/challenge-finding-base-type-of-nested-optionals/25096
/// - seealso: https://stackoverflow.com/a/32781143/456536

fileprivate protocol OptionalProtocol {
    static var wrappedType: Any.Type { get }
    var wrappedType: Any.Type { get }
    var wrapped: Any? { get }
}

extension Optional: OptionalProtocol {
    
    public static var wrappedType: Any.Type {
        if let optional = Wrapped.self as? OptionalProtocol.Type {
            return optional.wrappedType
        }
        return Wrapped.self
    }
    
    public var wrappedType: Any.Type {
        return Self.wrappedType
    }
    
    public var wrapped: Any? {
        return switch self {
            case .some(let optional as OptionalProtocol):
                optional.wrapped
            case .some(let wrapped):
                wrapped
            case .none:
                nil
        }
    }
}
