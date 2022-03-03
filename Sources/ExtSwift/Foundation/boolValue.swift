//
//  Falsify.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-07.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

// MARK: - protocol

/// - seealso: https://developer.mozilla.org/en-US/docs/Glossary/Falsy
public protocol Falsifiable {
    var isFalsy: Bool { get }
}

public extension Falsifiable {
    var isTruthy: Bool {
        return !isFalsy
    }
}

// MARK: - extension

extension Bool   : Falsifiable { public var isFalsy: Bool { return !self       } }
extension Int    : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension Int8   : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension Int16  : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension Int32  : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension Int64  : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension UInt   : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension UInt8  : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension UInt16 : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension UInt32 : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension UInt64 : Falsifiable { public var isFalsy: Bool { return self == 0   } }
extension Double : Falsifiable { public var isFalsy: Bool { return self == 0.0 } }
extension Float  : Falsifiable { public var isFalsy: Bool { return self == 0.0 } }
// public typealias Float32 = Float
// public typealias Float64 = Double
#if arch(i386) || arch(x86_64)
extension Float80: Falsifiable { public var isFalsy: Bool { return self == 0.0 } }
#endif

// NO: extension String    : Falsifiable { public var isFalsy: Bool { return !isEmpty } }
// NO: extension Array<Any>: Falsifiable { public var isFalsy: Bool { return !isEmpty } }

extension Optional: Falsifiable {
    public var isFalsy: Bool {
        switch self {
            case .some(let v):
                if let f = v as? Falsifiable {
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
extension NSNumber: Falsifiable { public var isFalsy: Bool { return self == 0.0 } }
#if canImport(CoreGraphics)
extension CGFloat:  Falsifiable { public var isFalsy: Bool { return self == 0.0 } }
#endif
