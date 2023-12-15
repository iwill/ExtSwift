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
        if let value = any as? T {
            return value
        }
        else if let value = any as? NSNumber {
            return value.as(type)
        }
        else if let value = any as? NSString {
            return value.as(type)
        }
        return nil
    }
}

public extension Array where Element == Any {
    subscript<T>(index: Index, as type: T.Type) -> T? {
        let any = self[try: index]
        if let value = any as? T {
            return value
        }
        else if let value = any as? NSNumber {
            return value.as(type)
        }
        else if let value = any as? NSString {
            return value.as(type)
        }
        return nil
    }
}

public extension NSNumber {
    func `as`<T>(_ type: T.Type) -> T? {
        if let value = self as? T {
            return value
        }
        switch type {
            case is Double.Type:    return doubleValue  as? T
            case is Float.Type:     return floatValue   as? T
            #if canImport(CoreGraphics)
            case is CGFloat.Type:   return doubleValue  as? T
            #endif
            case is Int.Type:       return intValue     as? T
            case is Int8.Type:      return int8Value    as? T
            case is Int16.Type:     return int16Value   as? T
            case is Int32.Type:     return int32Value   as? T
            case is Int64.Type:     return int64Value   as? T
            case is UInt.Type:      return uintValue    as? T
            case is UInt8.Type:     return uint8Value   as? T
            case is UInt16.Type:    return uint16Value  as? T
            case is UInt32.Type:    return uint32Value  as? T
            case is UInt64.Type:    return uint64Value  as? T
            case is Bool.Type:      return boolValue    as? T
            case is String.Type:    return stringValue  as? T
            default: return nil
        }
    }
}
public extension NSString {
    func `as`<T>(_ type: T.Type) -> T? {
        if let value = self as? T {
            return value
        }
        switch type {
            case is Double.Type:    return doubleValue          as? T
            case is Float.Type:     return floatValue           as? T
            #if canImport(CoreGraphics)
            case is CGFloat.Type:   return doubleValue          as? T
            #endif
            case is Int.Type:       return integerValue         as? T
            case is Int8.Type:      return Int8(integerValue)   as? T
            case is Int16.Type:     return Int16(integerValue)  as? T
            case is Int32.Type:     return Int32(integerValue)  as? T
            case is Int64.Type:     return Int64(integerValue)  as? T
            case is UInt.Type:      return UInt(integerValue)   as? T
            case is UInt8.Type:     return UInt8(integerValue)  as? T
            case is UInt16.Type:    return UInt16(integerValue) as? T
            case is UInt32.Type:    return UInt32(integerValue) as? T
            case is UInt64.Type:    return UInt64(integerValue) as? T
            case is Bool.Type:      return boolValue            as? T
            default: return nil
        }
    }
}
