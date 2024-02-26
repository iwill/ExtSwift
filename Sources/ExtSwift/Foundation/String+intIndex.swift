//
//  String+IntIndex.swift
//  ExtSwift
//
//  Created by Míng on 2021-03-19.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension String {
    
    // MARK: index
    
    func index(from intIndex: Int) -> Index? {
        let intIndex = intIndex >= 0 ? intIndex : count + intIndex
        return index(startIndex, offsetBy: intIndex, limitedBy: endIndex)
    }
    func intIndex(from index: Index) -> Int {
        return distance(from: startIndex, to: index)
    }
    
    func firstIntIndex(of element: Character) -> Int? {
        if let index = firstIndex(of: element) {
            return intIndex(from: index)
        }
        return nil
    }
    func firstIntIndex(where predicate: (Character) throws -> Bool) rethrows -> Int? {
        if let index = try firstIndex(where: predicate) {
            return intIndex(from: index)
        }
        return nil
    }
    
    func lastIntIndex(of element: Character) -> Int? {
        if let index = lastIndex(of: element) {
            return intIndex(from: index)
        }
        return nil
    }
    func lastIntIndex(where predicate: (Character) throws -> Bool) rethrows -> Int? {
        if let index = try lastIndex(where: predicate) {
            return intIndex(from: index)
        }
        return nil
    }
    
    // MARK: range
    
    func range(from intRange: Range<Int>) -> Range<Index>? {
        guard let lowerIndex = index(from: intRange.lowerBound),
              let upperIndex = index(from: intRange.upperBound)
        else { return nil }
        return lowerIndex..<upperIndex
    }
    func range(from intRange: ClosedRange<Int>) -> ClosedRange<Index>? {
        guard let lowerIndex = index(from: intRange.lowerBound),
              let upperIndex = index(from: intRange.upperBound)
        else { return nil }
        return lowerIndex...upperIndex
    }
    func range(from intRange: PartialRangeUpTo<Int>) -> PartialRangeUpTo<Index>? {
        guard let upperIndex = index(from: intRange.upperBound)
        else { return nil }
        return ..<upperIndex
    }
    func range(from intRange: PartialRangeThrough<Int>) -> PartialRangeThrough<Index>? {
        guard let upperIndex = index(from: intRange.upperBound)
        else { return nil }
        return ...upperIndex
    }
    func range(from intRange: PartialRangeFrom<Int>) -> PartialRangeFrom<Index>? {
        guard let lowerIndex = index(from: intRange.lowerBound)
        else { return nil }
        return lowerIndex...
    }
    
    func intRange(from range: Range<Index>) -> Range<Int> {
        let lowerIndex = intIndex(from: range.lowerBound)
        let upperIndex = intIndex(from: range.upperBound)
        return lowerIndex..<upperIndex
    }
    func intRange(from range: ClosedRange<Index>) -> ClosedRange<Int> {
        let lowerIndex = intIndex(from: range.lowerBound)
        let upperIndex = intIndex(from: range.upperBound)
        return lowerIndex...upperIndex
    }
    func intRange(from range: PartialRangeUpTo<Index>) -> PartialRangeUpTo<Int> {
        let upperIndex = intIndex(from: range.upperBound)
        return ..<upperIndex
    }
    func intRange(from range: PartialRangeThrough<Index>) -> PartialRangeThrough<Int> {
        let upperIndex = intIndex(from: range.upperBound)
        return ...upperIndex
    }
    func intRange(from range: PartialRangeFrom<Index>) -> PartialRangeFrom<Int> {
        let lowerIndex = intIndex(from: range.lowerBound)
        return lowerIndex...
    }
    
    // MARK: subscript
    
    subscript(_ intIndex: Int) -> Character? {
        guard let index = index(from: intIndex) else { return nil }
        return self[index]
    }
    
    subscript(_ intRange: Range<Int>) -> Substring? {
        guard let range = range(from: intRange) else { return nil }
        return self[range]
    }
    subscript(_ intRange: ClosedRange<Int>) -> Substring? {
        guard let range = range(from: intRange) else { return nil }
        return self[range]
    }
    subscript(_ intRange: PartialRangeUpTo<Int>) -> Substring? {
        guard let range = range(from: intRange) else { return nil }
        return self[range]
    }
    subscript(_ intRange: PartialRangeThrough<Int>) -> Substring? {
        guard let range = range(from: intRange) else { return nil }
        return self[range]
    }
    subscript(_ intRange: PartialRangeFrom<Int>) -> Substring? {
        guard let range = range(from: intRange) else { return nil }
        return self[range]
    }
    
    // MARK: mutating
    
    mutating func insert(_ newElement: Character, at intIndex: Int) {
        guard let index = index(from: intIndex) else { return }
        insert(newElement, at: index)
    }
    mutating func insert<C>(contentsOf newElements: C, at intIndex: Int) where C: Collection, C.Element == Element {
        guard let index = index(from: intIndex) else { return }
        insert(contentsOf: newElements, at: index)
    }
    
    mutating func replaceSubrange<C>(_ intRange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        guard let range = range(from: intRange) else { return }
        replaceSubrange(range, with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: ClosedRange<Int>, with newElements: C) where C: Collection, C.Element == Element {
        guard let range = range(from: intRange) else { return }
        replaceSubrange(range, with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: PartialRangeUpTo<Int>, with newElements: C) where C: Collection, C.Element == Element {
        guard let range = range(from: intRange) else { return }
        replaceSubrange(range, with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: PartialRangeThrough<Int>, with newElements: C) where C: Collection, C.Element == Element {
        guard let range = range(from: intRange) else { return }
        replaceSubrange(range, with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: PartialRangeFrom<Int>, with newElements: C) where C: Collection, C.Element == Element {
        guard let range = range(from: intRange) else { return }
        replaceSubrange(range, with: newElements)
    }
    
    mutating func remove(at intIndex: Int) -> Character? {
        guard let index = index(from: intIndex) else { return nil }
        return remove(at: index)
    }
    mutating func removeSubrange(_ intRange: Range<Int>) {
        guard let range = range(from: intRange) else { return }
        removeSubrange(range)
    }
    
    // MARK: new string
    
    func replacingCharacters<T>(in intRange: Range<Int>, with replacement: T) -> String where T: StringProtocol {
        guard let range = range(from: intRange) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    func replacingCharacters<T>(in intRange: ClosedRange<Int>, with replacement: T) -> String where T: StringProtocol {
        guard let range = range(from: intRange) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    func replacingCharacters<T>(in intRange: PartialRangeUpTo<Int>, with replacement: T) -> String where T: StringProtocol {
        guard let range = range(from: intRange) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    func replacingCharacters<T>(in intRange: PartialRangeThrough<Int>, with replacement: T) -> String where T: StringProtocol {
        guard let range = range(from: intRange) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    func replacingCharacters<T>(in intRange: PartialRangeFrom<Int>, with replacement: T) -> String where T: StringProtocol {
        guard let range = range(from: intRange) else { return self }
        return replacingCharacters(in: range, with: replacement)
    }
    
    // only `Range<Int>?`
    func replacingOccurrences<Target, Replacement>(of target: Target, with replacement: Replacement, options: String.CompareOptions = [], range intRange: Range<Int>? = nil) -> String where Target: StringProtocol, Replacement: StringProtocol {
        // ???: let range = intRange.transform { self.range(from: $0) }
        let range = intRange != nil ? range(from: intRange!) : nil
        return replacingOccurrences(of: target, with: replacement, options: options, range: range)
    }
}
