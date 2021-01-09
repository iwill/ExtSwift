//
//  Falsify.swift
//  
//
//  Created by MingLQ on 2021-01-07.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - protocol

/// - seealso: https://developer.mozilla.org/en-US/docs/Glossary/Falsy
public protocol Falsify {
    var isFalsy: Bool { get }
}

public extension Falsify {
    var isTruthy: Bool {
        return !isFalsy
    }
}

// MARK: - extension

extension Bool   : Falsify { public var isFalsy: Bool { return !self       } }
extension Int    : Falsify { public var isFalsy: Bool { return self == 0   } }
extension Int8   : Falsify { public var isFalsy: Bool { return self == 0   } }
extension Int16  : Falsify { public var isFalsy: Bool { return self == 0   } }
extension Int32  : Falsify { public var isFalsy: Bool { return self == 0   } }
extension Int64  : Falsify { public var isFalsy: Bool { return self == 0   } }
extension UInt   : Falsify { public var isFalsy: Bool { return self == 0   } }
extension UInt8  : Falsify { public var isFalsy: Bool { return self == 0   } }
extension UInt16 : Falsify { public var isFalsy: Bool { return self == 0   } }
extension UInt32 : Falsify { public var isFalsy: Bool { return self == 0   } }
extension UInt64 : Falsify { public var isFalsy: Bool { return self == 0   } }
extension Double : Falsify { public var isFalsy: Bool { return self == 0.0 } }
extension Float  : Falsify { public var isFalsy: Bool { return self == 0.0 } }
// public typealias Float32 = Float
// public typealias Float64 = Double
#if arch(i386) || arch(x86_64)
extension Float80: Falsify { public var isFalsy: Bool { return self == 0.0 } }
#endif

// NO: extension String : Falsify { public var isFalsy: Bool { return !isEmpty } }
// NO: extension Array<Any>: Falsify { public var isFalsy: Bool { return !isEmpty } }

extension Optional: Falsify {
    public var isFalsy: Bool {
        switch self {
        case .some(let v):
            if let f = v as? Falsify {
                return f.isFalsy
            }
            else {
                return false
            }
        default:
            return true
        }
    }
}

// OC Types
extension NSNumber: Falsify { public var isFalsy: Bool { return self == 0.0 } }
#if canImport(CoreGraphics)
extension CGFloat:  Falsify { public var isFalsy: Bool { return self == 0.0 } }
#endif
