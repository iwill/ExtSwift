//
//  String+IntIndex.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-03-19.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

public extension String {
    
    // MARK: index
    
    func index(from intIndex: Int) -> Index {
        return index(startIndex, offsetBy: intIndex)
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
    
    func range(from intRange: Range<Int>) -> Range<Index> {
        let lowerIndex = index(startIndex, offsetBy: intRange.lowerBound)
        let upperIndex = index(startIndex, offsetBy: intRange.upperBound)
        return lowerIndex..<upperIndex
    }
    func range(from intRange: ClosedRange<Int>) -> ClosedRange<Index> {
        let lowerIndex = index(startIndex, offsetBy: intRange.lowerBound)
        let upperIndex = index(startIndex, offsetBy: intRange.upperBound)
        return lowerIndex...upperIndex
    }
    func range(from intRange: PartialRangeUpTo<Int>) -> PartialRangeUpTo<Index> {
        let upperIndex = index(startIndex, offsetBy: intRange.upperBound)
        return ..<upperIndex
    }
    func range(from intRange: PartialRangeThrough<Int>) -> PartialRangeThrough<Index> {
        let upperIndex = index(startIndex, offsetBy: intRange.upperBound)
        return ...upperIndex
    }
    func range(from intRange: PartialRangeFrom<Int>) -> PartialRangeFrom<Index> {
        let lowerIndex = index(startIndex, offsetBy: intRange.lowerBound)
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
    
    subscript(_ intIndex: Int) -> Character {
        return self[index(from: intIndex)]
    }
    
    subscript(_ intRange: Range<Int>) -> Substring {
        return self[range(from: intRange)]
    }
    subscript(_ intRange: ClosedRange<Int>) -> Substring {
        return self[range(from: intRange)]
    }
    subscript(_ intRange: PartialRangeUpTo<Int>) -> Substring {
        return self[range(from: intRange)]
    }
    subscript(_ intRange: PartialRangeThrough<Int>) -> Substring {
        return self[range(from: intRange)]
    }
    subscript(_ intRange: PartialRangeFrom<Int>) -> Substring {
        return self[range(from: intRange)]
    }
    
    // MARK: mutating
    
    mutating func insert(_ newElement: Character, at intIndex: Int) {
        insert(newElement, at: index(from: intIndex))
    }
    mutating func insert<C>(contentsOf newElements: C, at intIndex: Int) where C: Collection, C.Element == Element {
        insert(contentsOf: newElements, at: index(from: intIndex))
    }
    
    mutating func replaceSubrange<C>(_ intRange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubrange(range(from: intRange), with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: ClosedRange<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubrange(range(from: intRange), with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: PartialRangeUpTo<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubrange(range(from: intRange), with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: PartialRangeThrough<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubrange(range(from: intRange), with: newElements)
    }
    mutating func replaceSubrange<C>(_ intRange: PartialRangeFrom<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubrange(range(from: intRange), with: newElements)
    }
    
    mutating func remove(at intIndex: Int) -> Character {
        return remove(at: index(from: intIndex))
    }
    mutating func removeSubrange(_ intRange: Range<Int>) {
        removeSubrange(range(from: intRange))
    }
    
    // MARK: new string
    
    func replacingCharacters<T>(in intRange: Range<Int>, with replacement: T) -> String where T: StringProtocol {
        return replacingCharacters(in: range(from: intRange), with: replacement)
    }
    func replacingCharacters<T>(in intRange: ClosedRange<Int>, with replacement: T) -> String where T: StringProtocol {
        return replacingCharacters(in: range(from: intRange), with: replacement)
    }
    func replacingCharacters<T>(in intRange: PartialRangeUpTo<Int>, with replacement: T) -> String where T: StringProtocol {
        return replacingCharacters(in: range(from: intRange), with: replacement)
    }
    func replacingCharacters<T>(in intRange: PartialRangeThrough<Int>, with replacement: T) -> String where T: StringProtocol {
        return replacingCharacters(in: range(from: intRange), with: replacement)
    }
    func replacingCharacters<T>(in intRange: PartialRangeFrom<Int>, with replacement: T) -> String where T: StringProtocol {
        return replacingCharacters(in: range(from: intRange), with: replacement)
    }
    
    // only `Range<Int>?`
    func replacingOccurrences<Target, Replacement>(of target: Target, with replacement: Replacement, options: CompareOptions = [], range intRange: Range<Int>? = nil) -> String where Target: StringProtocol, Replacement: StringProtocol {
        return replacingOccurrences(of: target, with: replacement, options: options, range: intRange.map { range(from: $0) })
    }
}
