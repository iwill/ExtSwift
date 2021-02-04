//
//  NameSpace.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// MARK: NameSpace

public struct NameSpace<Base> {
    public let _base: Base
    public init(_ base: Base) {
        self._base = base
    }
}

// MARK: - builtin `.es`

public typealias ES = NameSpace
public protocol  ESNameSpace {}
public extension ESNameSpace {
    static var es: ES<Self>.Type { return ES<Self>.self }
    var es: ES<Self> { return ES(self) }
}
