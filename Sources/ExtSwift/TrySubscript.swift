//
//  TrySubscript.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-01-12.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

/// - seealso:
/// [Say Goodbye to "Index out of range" - Swift](https://medium.com/flawless-app-stories/say-goodbye-to-index-out-of-range-swift-eca7c4c7b6ca)
/// [SwiftKit](https://github.com/wendyliga/SwiftKit)
extension Collection where Indices.Iterator.Element == Index {
    public subscript(try index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
