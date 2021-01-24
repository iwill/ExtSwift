//
//  Operators.swift
//  
//
//  Created by MingLQ on 2021-01-07.
//

import Foundation

prefix operator    !? // isNil:   !?value  !value
prefix operator    ?? // notNil:  ??value  a ?? b
public prefix func !? <T>(v: T?) -> Bool { return v == nil }
public prefix func ?? <T>(v: T?) -> Bool { return v != nil }

prefix operator     ! // isFalsy:    !value  == NOT!
prefix operator    !! // isTruthy:  !!value  NOT! NOT!
public prefix func  ! <T>(v: T?) -> Bool { return v.isFalsy }
public prefix func !! <T>(v: T?) -> Bool { return v.isTruthy }

precedencegroup FalsyCoalescingPrecedence {
    associativity: right
    lowerThan: NilCoalescingPrecedence
    higherThan: ComparisonPrecedence
}
infix  operator ??! : FalsyCoalescingPrecedence // a ??! b  >  a.isTruthy ? a : b
infix  operator ?!! : FalsyCoalescingPrecedence // a ?!! b  >  a.isFalsy  ? a : b
public func     ??! <T>(l: T?, r: T?) -> T? { return !!l ? l : r }
// public func     ??! <T>(l: T , r: T?) -> T? { return !!l ? l : r }
// public func     ??! <T>(l: T?, r: T ) -> T? { return !!l ? l : r }
// public func     ??! <T>(l: T , r: T ) -> T  { return !!l ? l : r }
@available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
public func     ?!! <T>(l: T?, r: T?) -> T? { return  !l ? l : r }
// @available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
// public func     ?!! <T>(l: T , r: T?) -> T? { return  !l ? l : r }
// @available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
// public func     ?!! <T>(l: T?, r: T ) -> T? { return  !l ? l : r }
// @available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
// public func     ?!! <T>(l: T , r: T ) -> T  { return  !l ? l : r }
