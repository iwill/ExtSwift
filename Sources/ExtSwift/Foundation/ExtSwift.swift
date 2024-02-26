//
//  Falsify.swift
//  ExtSwift
//
//  Created by Míng on 2021-01-09.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

internal struct ExtSwift {
    var text = "Hello, ExtSwift!"
}

// TODO: move to String+?.swift

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension BidirectionalCollection where Self.SubSequence == Substring {
    public func ends(with regex: some RegexComponent) -> Bool {
        guard let match = matches(of: regex).last else { return false }
        return match.range.upperBound == endIndex
    }
}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension Regex {
    
    public func suffixMatch(in string: String) throws -> Regex<Output>.Match? {
        guard let match = string.matches(of: self).last else { return nil }
        return match.range.upperBound == string.endIndex ? match : nil
    }
    
    public func suffixMatch(in string: Substring) throws -> Regex<Output>.Match? {
        return try suffixMatch(in: String(string))
    }
    
    public func lastMatch(in string: String) throws -> Regex<Output>.Match? {
        return string.matches(of: self).last
    }
    
    public func lastMatch(in string: Substring) throws -> Regex<Output>.Match? {
        return try lastMatch(in: String(string))
    }
}

public extension String {
    init(localizedFormat: String, comment: String? = nil, _ arguments: CVarArg...) {
        self.init(format: NSLocalizedString(localizedFormat, comment: comment ?? ""), arguments)
    }
}
