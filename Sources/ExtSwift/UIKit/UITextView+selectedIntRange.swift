//
//  UITextView+selectedIntRange.swift
//  ExtSwift
//
//  Created by Míng on 2024-02-07.
//  Copyright (c) 2024 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

/// UITextView

/// Range<Int> <-> Range<String.Index> <-> NSRange <-> UITextRange

/// 1. Range<String.Index> <-> Range<Int>
/// - string.intRange(from: range)
/// - string.range(from: intRange)

/// 2.1. Range<String.Index> from NSRange
// extension Range where Bound == String.Index {
//     public init?(_ range: NSRange, in string: String)
//     public init?<S>(_ range: NSRange, in string: S) where S : StringProtocol
// }

/// 2.2. Range<Int> from NSRange
extension Range where Bound == Int {
    public init?(_ nsRange: NSRange, in string: String) {
        guard let range = Range<String.Index>(nsRange, in: string) else { return nil }
        let intRange = string.intRange(from: range)
        self = intRange
    }
    public init?<S>(_ nsRange: NSRange, in string: S) where S : StringProtocol {
        guard let range = Range<String.Index>(nsRange, in: string) else { return nil }
        let intRange = string.intRange(from: range)
        self = intRange
    }
}

/// 3.1. NSRange from Range<String.Index>
// extension NSRange {
//     public init<R, S>(_ region: R, in target: S) where R : RangeExpression, S : StringProtocol, R.Bound == String.Index
// }

/// 3.2. NSRange from Range<String.Int>
extension NSRange {
    // ???: ClosedRange, PartialRangeUpTo, PartialRangeThrough, PartialRangeFrom
    public init?<S>(_ intRange: Range<Int>, in string: S) where S : StringProtocol {
        guard let range = string.range(from: intRange) else { return nil }
        self.init(range, in: string)
    }
}

/// 4. UITextRange from/to NSRange, Range<String.Index>, Range<Int>

extension UITextView {
    
    func textRange(from nsRange: NSRange) -> UITextRange? {
        guard let beginning = position(from: beginningOfDocument, offset: nsRange.location),
              let end = position(from: beginning, offset: nsRange.length),
              let textRange = textRange(from: beginning, to: end) else { return nil }
        return textRange
    }
    func textRange(from range: Range<String.Index>) -> UITextRange? {
        let nsRange = NSRange(range, in: text)
        return textRange(from: nsRange)
    }
    func textRange(from intRange: Range<Int>) -> UITextRange? {
        guard let nsRange = NSRange(intRange, in: text) else { return nil }
        return textRange(from: nsRange)
    }
    
    func nsRange(from textRange: UITextRange) -> NSRange {
        let location = offset(from: beginningOfDocument, to: textRange.start),
            length = offset(from: textRange.start, to: textRange.end)
        return NSRange(location: location, length: length)
    }
    func range(from textRange: UITextRange) -> Range<String.Index>? {
        let nsRange = nsRange(from: textRange)
        return Range<String.Index>(nsRange, in: text)
    }
    func range(from textRange: UITextRange) -> Range<Int>? {
        let nsRange = nsRange(from: textRange)
        return Range<Int>(nsRange, in: text)
    }
}

/// Range<Int> in UITextView

public extension UITextView {
    
    var selectedIntRange: Range<Int> {
        get { Range<Int>(selectedRange, in: text)! }
        set { selectedRange = NSRange(newValue, in: text) ?? NSRange(location: NSNotFound, length: 0) }
    }
    
    func replace(_ intRange: Range<Int>, withText text: String) {
        let textRange = textRange(from: intRange)!
        replace(textRange, withText: text)
    }
    
    func scrollRangeToVisible(_ intRange: Range<Int>) {
        guard let nsRange = NSRange(intRange, in: text) else { return }
        scrollRangeToVisible(nsRange)
    }
}
