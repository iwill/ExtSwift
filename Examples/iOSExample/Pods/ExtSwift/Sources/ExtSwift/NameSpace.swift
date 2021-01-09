//
//  NameSpace.swift
//  
//
//  Created by MingLQ on 2021-01-07.
//

import Foundation

// MARK: NameSpace

open class NameSpace<Base> {
    let _base: Base
    init(_ base: Base) {
        self._base = base
    }
}

// MARK: - builtin `.es`

public protocol ExtSwiftNameSpace {
}
public extension ExtSwiftNameSpace {
    var es: NameSpace<Self> { return NameSpace(self) }
}
