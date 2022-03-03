//
//  Operators.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-01-07.
//  Copyright (c) 2021 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// MARK: - isNil & notNil

prefix operator    !? // `!?value == value.isNil`,  from `!value` and `value?`
prefix operator    ?? // `??value == value.notNil`, from `a ?? b`

public prefix func !? <T>(v: T?) -> Bool { return v == nil }
public prefix func ?? <T>(v: T?) -> Bool { return v != nil }

// MARK: - boolValue & !boolValue

prefix operator     !! //  `!!value ==  value.boolValue`
prefix operator    !!! // `!!!value == !value.boolValue`

public prefix func  !! <T>(v: T?) -> Bool { return  v.boolValue }
public prefix func !!! <T>(v: T?) -> Bool { return !v.boolValue }

// MARK: - FalsyCoalescing

// - seealso: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
precedencegroup FalsyCoalescingPrecedence {
    associativity: right
    lowerThan: NilCoalescingPrecedence
    higherThan: ComparisonPrecedence
}

infix  operator ??!: FalsyCoalescingPrecedence // a ??! b  >  a.isTruthy ? a : b

public func     ??! <T>(l: T, r: T) -> T { return !!l ? l : r }
