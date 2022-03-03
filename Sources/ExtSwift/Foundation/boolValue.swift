//
//  boolValue.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-01-07.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - protocol

public protocol BoolValue {
    var boolValue: Bool { get }
}

// MARK: - extension

extension Bool   : BoolValue { public var boolValue: Bool { return self        } }
extension Int    : BoolValue { public var boolValue: Bool { return self != 0   } }
extension Int8   : BoolValue { public var boolValue: Bool { return self != 0   } }
extension Int16  : BoolValue { public var boolValue: Bool { return self != 0   } }
extension Int32  : BoolValue { public var boolValue: Bool { return self != 0   } }
extension Int64  : BoolValue { public var boolValue: Bool { return self != 0   } }
extension UInt   : BoolValue { public var boolValue: Bool { return self != 0   } }
extension UInt8  : BoolValue { public var boolValue: Bool { return self != 0   } }
extension UInt16 : BoolValue { public var boolValue: Bool { return self != 0   } }
extension UInt32 : BoolValue { public var boolValue: Bool { return self != 0   } }
extension UInt64 : BoolValue { public var boolValue: Bool { return self != 0   } }
extension Double : BoolValue { public var boolValue: Bool { return self != 0.0 } }
extension Float  : BoolValue { public var boolValue: Bool { return self != 0.0 } }
// public typealias Float32 = Float
// public typealias Float64 = Double
#if arch(i386) || arch(x86_64)
extension Float80: BoolValue { public var boolValue: Bool { return self != 0.0 } }
#endif

// NO: extension String    : BoolValue { public var boolValue: Bool { return !isEmpty } }
// NO: extension Array<Any>: BoolValue { public var boolValue: Bool { return !isEmpty } }

extension Optional: BoolValue {
    public var boolValue: Bool {
        switch self {
            case .some(let v):
                if let b = v as? BoolValue {
                    return b.boolValue
                }
                else {
                    return true
                }
            default:
                return false
        }
    }
}

// OC Types
extension NSNumber: BoolValue {}
#if canImport(CoreGraphics)
extension CGFloat:  BoolValue { public var boolValue: Bool { return self != 0.0 } }
#endif
