//
//  NameSpace.swift
//  
//
//  Created by MingLQ on 2021-01-07.
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
    var es: ES<Self> { return ES(self) }
}
