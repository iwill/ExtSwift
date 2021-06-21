//
//  tryIndex.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-12.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// - seealso:
/// [Say Goodbye to "Index out of range" - Swift](https://medium.com/flawless-app-stories/say-goodbye-to-index-out-of-range-swift-eca7c4c7b6ca)
/// [SwiftKit](https://github.com/wendyliga/SwiftKit)
public extension Collection {
    
    subscript(try index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    /// supports negative-integer as backward-index: `-1` -> `count - 1`
    subscript(try index: Index) -> Iterator.Element? where Self.Index == Int {
        let index = index >= 0 ? index : count + index
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    subscript<R>(try rangeExpression: R) -> Self.SubSequence? where R: RangeExpression, Self.Index == R.Bound {
        let limit = startIndex..<endIndex
        let range = rangeExpression.relative(to: self).clamped(to: limit)
        guard !range.isEmpty else {
            return nil
        }
        return self[range]
    }
}

/* avoid this:
 *  var array = [0, 1, 2]
 *  array[try: 999] = 999 // NO warning, NO error and NO effect
public extension Array {
    subscript(try index: Index) -> Iterator.Element? {
        get {
            guard indices.contains(index) else { return nil }
            return self[index]
        }
        set {
            if let newValue = newValue {
                guard indices.contains(index) || index == endIndex else { return }
                self[index] = newValue
            }
            else {
                guard indices.contains(index) else { return }
                remove(at: index)
            }
        }
    }
} */

// MARK: - bidirectIndex of RangeExpression

@available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
public extension Collection {
    
    /// supports `bidirectIndex` in `RangeExpression`
    subscript<R>(tryBidirectRange rangeExpression: R) -> Self.SubSequence? where R: RangeExpression, Self.Index == R.Bound, Self.Index == Int {
        
        func relative(bidirectIndex: Int, to count: Int) -> Int {
            guard let negative = negative(from: bidirectIndex) else {
                return bidirectIndex
            }
            return count + negative
        }
        
        var range = rangeExpression.relative(to: self)
        
        let lower = relative(bidirectIndex: range.lowerBound, to: count)
        let upper = relative(bidirectIndex: range.upperBound, to: count)
        range = lower..<Swift.max(lower, upper)
        
        let limit = startIndex..<endIndex
        range = range.clamped(to: limit)
        
        guard !range.isEmpty else {
            return nil
        }
        return self[range]
    }
}

/// negative: `(-1023)...0`
///     common-index: `0..<(Int.max - 1023)`
///     `bidirectIndex`: `(Int.max - 1023)...Int.max`
/// return: `bidirectIndex`
@available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
public func bidirectIndex(from negative: Int) -> Int? {
    guard negative <= 0 && negative > -1024 else {
        return nil
    }
    return Int.max + negative
}

@available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
public func negative(from bidirectIndex: Int) -> Int? {
    guard isBidirectIndex(bidirectIndex) else {
        return nil
    }
    return bidirectIndex - Int.max
}

@available(*, deprecated, message: "UNSTABLE API - Maybe it's not necessary!")
public func isBidirectIndex(_ bidirectIndex: Int) -> Bool {
    return bidirectIndex > Int.max - 1024
}
