//
//  UITextView+selectedIntRange.swift
//  ExtSwift
//
//  Created by Míng on 2024-02-07.
//  Copyright (c) 2024 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

public extension NSRange {
    
    func range<S>(in string: S) -> Range<String.Index>? where S : StringProtocol {
        return Range(self, in: string)
    }
    
    func intRange<S>(in string: S) -> Range<Int>? where S : StringProtocol {
        return Range(self, in: string).transform { string.intRange(from: $0) }
    }
}

public extension UITextView {
    
    var selectedIntRange: Range<Int> {
        get {
            let nsRange: NSRange = selectedRange
            guard let strRange: Range<String.Index> = Range(nsRange, in: text) else { return 0..<0 }
            let intRange: Range<Int> = text.intRange(from: strRange)
            return intRange
        }
        set {
            let intRange = newValue
            guard let strRange: Range<String.Index> = text.range(from: intRange) else { return }
            let nsRange: NSRange = NSRange(strRange, in: text)
            selectedRange = nsRange
        }
    }
    
    func replace(_ intRange: Range<Int>, withText text: String) {
        guard let beginning = position(from: beginningOfDocument, offset: intRange.lowerBound),
              let end = position(from: beginningOfDocument, offset: intRange.upperBound),
              let textRange = textRange(from: beginning, to: end) else { return }
        replace(textRange, withText: text)
    }
}
