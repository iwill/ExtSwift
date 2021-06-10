//
//  SemanticVersion.swift
//  
//
//  Created by MingLQ on 2021-05-19.
//

import Foundation

/// # Semantic-Versioning:
/// > https://semver.org/

/// # Features:
/// 
/// Sorting versions in the following order:
/// 
///     ```
///     LOWER
///     1.2         !!!: NON Semantic-Versioning
///     1.2.0-alpha pre-release version
///     1.2.0-beta  pre-release version
///     1.2.0       normal version
///     1.2.0+build normal version + build metadata
///     1.2.0.0     !!!: NON Semantic-Versioning
///     1.2.99      normal version
///     1.11.0      normal version
///     HIGHER
///     ```

/// # Suggestion:
/// 
/// - Use `<`, instead of `<=`
/// - Use `>=`, instead of `>`
/// - Remove all trailing `.0` from the comparing target when using via `<` or `>=`
/// 
///     ```
///     ✅ v <  2
///     ⚠️ v <= "1.99999999.99999999"
///     ⚠️ v <  2.0 // ❌ if v is 2.0.0
///     ✅ v >= 2
///     ⚠️ v >  "1.99999999.99999999"
///     ⚠️ v >= 2.0 // ❌ if v is 2
///     ✅ v >= 2 && v < 3
///     ✅ (v2..<v3).contains(v) // let v2 = 2 as SemanticVersion, v3 = 3 as SemanticVersion
///     ```

public struct SemanticVersion: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    
    public var stringLiteral: String
    
    public init(stringLiteral literal: String) {
        stringLiteral = literal
    }
    
    public init(integerLiteral literal: Int) {
        stringLiteral = String(literal)
    }
    
    public init(floatLiteral literal: Double) {
        stringLiteral = String(literal)
    }
}

extension SemanticVersion: Comparable {
    
    private var prepared: String {
        //  Char  |  \0  \t  \n  esc   ␣   +   -   .   0   9   A   a
        //  Dec   |   0   9  10   27  32  43  45  46  48  57  65  97
        //                                     ^ replace `-` with `\0`, which less than `\n`
        //                    ^ append `\n` which less than `+`, `.`, numbers and letters
        return stringLiteral.replacingOccurrences(of: "-", with: "\0") + "\n"
    }
    
    public static func < (a: SemanticVersion, b: SemanticVersion) -> Bool {
        return a.prepared.compare(b.prepared, options: .numeric) == .orderedAscending
    }
}

// MARK: EXTENSION

public extension String {
    var semanticVersion: SemanticVersion {
        return SemanticVersion(stringLiteral: self)
    }
}

public extension Int {
    var semanticVersion: SemanticVersion {
        return SemanticVersion(integerLiteral: self)
    }
}

public extension Double {
    var semanticVersion: SemanticVersion {
        return SemanticVersion(floatLiteral: self)
    }
}

// MARK: DEPRECATED

/*
public extension Comparable where Self == SemanticVersion {
    
    @available(*, deprecated, message: "Use `<` instead.")
    static func <= (a: Self, b: Self) -> Bool {
        return (a < b || a == b)
    }
    
    @available(*, deprecated, message: "Use `>=` instead.")
    static func > (a: Self, b: Self) -> Bool {
        return !(a < b || a == b)
    }
}

public extension SemanticVersion {
    
    @available(*, deprecated, message: "Use `..<` instead.")
    static func ... (minimum: Self, maximum: Self) -> ClosedRange<Self> {
        return ClosedRange(uncheckedBounds: (minimum, maximum))
    }
    
    @available(*, deprecated, message: "Use `..<` instead.")
    prefix static func ... (maximum: Self) -> PartialRangeThrough<Self> {
        return PartialRangeThrough(maximum)
    }
}
// */
