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
