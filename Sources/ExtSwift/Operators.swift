//
//  Operators.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// MARK: - isNil & notNil

prefix operator    !? // isNil:   !?value  !value
prefix operator    ?? // notNil:  ??value  a ?? b

public prefix func !? <T>(v: T?) -> Bool { return v == nil }
public prefix func ?? <T>(v: T?) -> Bool { return v != nil }

// MARK: - isFalsy & isTruthy

prefix operator    !!! // isFalsy:   !!!value  ==  NOT!
prefix operator     !! // isTruthy:   !!value  ==  NOT! NOT!

public prefix func !!! <T>(v: T?) -> Bool { return v.isFalsy }
public prefix func  !! <T>(v: T?) -> Bool { return v.isTruthy }

// MARK: - FalsyCoalescing

// - seealso: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
precedencegroup FalsyCoalescingPrecedence {
    associativity: right
    lowerThan: NilCoalescingPrecedence
    higherThan: ComparisonPrecedence
}

infix  operator ??! : FalsyCoalescingPrecedence // a ??! b  >  a.isTruthy ? a : b

public func     ??! <T>(l: T, r: T) -> T { return !!l ? l : r }
