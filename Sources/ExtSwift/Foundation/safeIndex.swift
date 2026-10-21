//
//  safeIndex.swift
//  ExtSwift
//
//  Created by Míng on 2026-10-21.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// - seealso:
/// [Say Goodbye to "Index out of range" - Swift](https://medium.com/flawless-app-stories/say-goodbye-to-index-out-of-range-swift-eca7c4c7b6ca)
/// [SwiftKit](https://github.com/wendyliga/SwiftKit)
public extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    /// supports negative-integer as backward-index: `-1` -> `count - 1`
    subscript(safe index: Index) -> Iterator.Element? where Self.Index == Int {
        let index = index >= 0 ? index : count + index
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    subscript<R>(safe rangeExpression: R) -> Self.SubSequence? where R: RangeExpression, Self.Index == R.Bound {
        let limit = startIndex..<endIndex
        let range = rangeExpression.relative(to: self).clamped(to: limit)
        guard !range.isEmpty else { return nil }
        return self[range]
    }
}

/* avoid this:
 *  var array = [0, 1, 2]
 *  array[safe: 999] = 999 // NO warning, NO error and NO effect
public extension Array {
    subscript(safe index: Index) -> Iterator.Element? {
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
