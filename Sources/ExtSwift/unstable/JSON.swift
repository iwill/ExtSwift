//
//  JSON.swift
//  ExtSwift
//
//  Created by Míng on 2021-03-15.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

/// JSON Type-Conversion

public extension Dictionary where Key == String, Value == Any {
    subscript<T>(key: Key, as type: T.Type) -> T? {
        let any = self[key]
        return if let value = any as? T { value }
        else if let value = any as? NSNumber { value.as(type) }
        else if let value = any as? NSString { value.as(type) }
        else { nil }
    }
}

public extension Array where Element == Any {
    subscript<T>(index: Index, as type: T.Type) -> T? {
        let any = self[try: index]
        return if let value = any as? T { value }
        else if let value = any as? NSNumber { value.as(type) }
        else if let value = any as? NSString { value.as(type) }
        else { nil }
    }
}

public extension NSNumber {
    func `as`<T>(_ type: T.Type) -> T? {
        if let value = self as? T {
            return value
        }
        return switch type {
            case is Double.Type:    doubleValue  as? T
            case is Float.Type:     floatValue   as? T
            #if canImport(CoreGraphics)
            case is CGFloat.Type:   doubleValue  as? T
            #endif
            case is Int.Type:       intValue     as? T
            case is Int8.Type:      int8Value    as? T
            case is Int16.Type:     int16Value   as? T
            case is Int32.Type:     int32Value   as? T
            case is Int64.Type:     int64Value   as? T
            case is UInt.Type:      uintValue    as? T
            case is UInt8.Type:     uint8Value   as? T
            case is UInt16.Type:    uint16Value  as? T
            case is UInt32.Type:    uint32Value  as? T
            case is UInt64.Type:    uint64Value  as? T
            case is Bool.Type:      boolValue    as? T
            case is String.Type:    stringValue  as? T
            default:                nil
        }
    }
}
public extension NSString {
    func `as`<T>(_ type: T.Type) -> T? {
        if let value = self as? T {
            return value
        }
        return switch type {
            case is Double.Type:    doubleValue          as? T
            case is Float.Type:     floatValue           as? T
            #if canImport(CoreGraphics)
            case is CGFloat.Type:   doubleValue          as? T
            #endif
            case is Int.Type:       integerValue         as? T
            case is Int8.Type:      Int8(integerValue)   as? T
            case is Int16.Type:     Int16(integerValue)  as? T
            case is Int32.Type:     Int32(integerValue)  as? T
            case is Int64.Type:     Int64(integerValue)  as? T
            case is UInt.Type:      UInt(integerValue)   as? T
            case is UInt8.Type:     UInt8(integerValue)  as? T
            case is UInt16.Type:    UInt16(integerValue) as? T
            case is UInt32.Type:    UInt32(integerValue) as? T
            case is UInt64.Type:    UInt64(integerValue) as? T
            case is Bool.Type:      boolValue            as? T
            default:                nil
        }
    }
}
