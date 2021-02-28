//
//  AnyEquatable.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-02-28.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public struct AnyEquatable: Equatable {
    public let base: Any
    private let isEqual: (AnyEquatable) -> Bool
    public init<E: Equatable>(_ base: E) {
        self.base = base
        self.isEqual = { base == $0.base as? E }
    }
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.isEqual(rhs) || rhs.isEqual(lhs)
    }
}
