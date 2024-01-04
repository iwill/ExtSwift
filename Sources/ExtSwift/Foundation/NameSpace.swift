//
//  NameSpace.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-07.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// MARK: NameSpace

public struct NameSpace<Base> {
    public let _base: Base
    public init(_ base: Base) {
        self._base = base
    }
}

// MARK: - builtin `.es` for ExtSwift

/// 0. define namespace `es`

public typealias ES = NameSpace

public protocol  ESNameSpace {}
public extension ESNameSpace {
    static var es: NameSpace<Self>.Type {
        get { NameSpace<Self>.self }
        set {}
    }
    var es: NameSpace<Self> {
        get { NameSpace(self) }
        set {}
    }
}

/// 1. add namespace `es` to `UIResponder` and its subclasses

/// extension UIResponder: ESNameSpace {}

/// 2. add custom properties or methods to `var es`

/// private var AssociatedObject_test: UInt8 = 0
/// public extension ES where Base: UIResponder {
///     var test: String? {
///         get {
///             return objc_getAssociatedObject(_base, &AssociatedObject_test) as? String
///         }
///         set {
///             objc_setAssociatedObject(_base, &AssociatedObject_test, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
///         }
///     }
/// }
