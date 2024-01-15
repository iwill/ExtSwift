//
//  Operators.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-07.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// MARK: - isNil & notNil

prefix operator     !?  // `!?value == value.isNil`,  from `!value` and `value?`
prefix operator     ??  // `??value == value.notNil`, from `a ?? b`

public prefix func  !? <T>(v: T?) -> Bool { v == nil }
public prefix func  ?? <T>(v: T?) -> Bool { v != nil }

// MARK: - boolValue & !boolValue

prefix operator      !! //  `!!value ==  value.boolValue`
prefix operator     !!! // `!!!value == !value.boolValue`

public prefix func   !! <T>(v: T?) -> Bool {  v.boolValue }
public prefix func  !!! <T>(v: T?) -> Bool { !v.boolValue }

// MARK: - FalsyCoalescing

// - seealso: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
precedencegroup FalsyCoalescingPrecedence {
    associativity: right
    lowerThan: NilCoalescingPrecedence
    higherThan: ComparisonPrecedence
}

infix  operator     ??! : FalsyCoalescingPrecedence // a ??! b  >  a.isTruthy ? a : b

@available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
public func         ??! <T>(l: T, r: T) -> T { return !!l ? l : r }

infix operator       ** : MultiplicationPrecedence

public func          ** (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
public func          ** (radix: Double, power: Int) -> Double {
    return pow(radix, Double(power))
}

infix operator      **= : AssignmentPrecedence

public func         **= (radix: inout Int, power: Int) {
    radix = radix ** power
}
public func         **= (radix: inout Double, power: Int) {
    radix = radix ** power
}
