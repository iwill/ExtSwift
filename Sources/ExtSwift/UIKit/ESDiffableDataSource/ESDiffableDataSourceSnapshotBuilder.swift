//
//  ESDiffableDataSourceSnapshotBuilder.swift
//  ExtSwift
//
//  Created by MingLQ on 2021-06-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#endif

@resultBuilder
public struct ESDiffableDataSourceSnapshotBuilder<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    public typealias SectionWithItems = (SectionIdentifierType?, [ItemIdentifierType])
}

// for [SectionWithItems]
public extension ESDiffableDataSourceSnapshotBuilder {
    
    static func buildBlock(_ components: [SectionWithItems]...) -> [SectionWithItems] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ components: [SectionWithItems]?) -> [SectionWithItems] {
        return components ?? []
    }
    
    static func buildEither(first components: [SectionWithItems]) -> [SectionWithItems] {
        return components
    }
    
    static func buildEither(second components: [SectionWithItems]) -> [SectionWithItems] {
        return components
    }
    
    static func buildArray(_ components: [[SectionWithItems]]) -> [SectionWithItems] {
        return components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: SectionWithItems) -> [SectionWithItems] {
        return [expression]
    }
    
    static func buildExpression(_ expression: [SectionWithItems]) -> [SectionWithItems] {
        return [expression].flatMap { $0 }
    }
    
    static func buildExpression(_ expression: SectionIdentifierType) -> [SectionWithItems] {
        return [(expression, [])]
    }
    
    static func buildExpression(_ expression: [SectionIdentifierType]) -> [SectionWithItems] {
        return expression.map { ($0, []) }
    }
    
    static func buildExpression(_ expression: ItemIdentifierType) -> [SectionWithItems] {
        return [(nil, [expression])]
    }
    
    static func buildExpression(_ expression: [ItemIdentifierType]) -> [SectionWithItems] {
        return [(nil, expression)]
    }
    
    static func buildFinalResult(_ components: [SectionWithItems]) -> ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        var snapshot = ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        for (section, items) in components {
            if section != nil {
                snapshot.appendSections([section!])
            }
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
}

// for nested [ItemIdentifierType]
public extension ESDiffableDataSourceSnapshotBuilder {
    
    static func buildBlock(_ components: [ItemIdentifierType]...) -> [ItemIdentifierType] {
        return components.flatMap { $0 }
    }
    
    static func buildOptional(_ components: [ItemIdentifierType]?) -> [ItemIdentifierType] {
        return components ?? []
    }
    
    static func buildEither(first components: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return components
    }
    
    static func buildEither(second components: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return components
    }
    
    static func buildArray(_ components: [[ItemIdentifierType]]) -> [ItemIdentifierType] {
        return components.flatMap { $0 }
    }
    
    static func buildExpression(_ expression: ItemIdentifierType) -> [ItemIdentifierType] {
        return [expression]
    }
    
    static func buildExpression(_ expression: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return expression
    }
    
    static func buildFinalResult(_ components: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return components
    }
}

// MARK: -

#if os(iOS) || os(tvOS)

public extension ESCollectionViewDiffableDataSource {
    func apply(@ESDiffableDataSourceSnapshotBuilder<SectionIdentifierType, ItemIdentifierType> _ snapshot: () -> ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) {
        apply(snapshot())
    }
}

public extension ESTableViewDiffableDataSource {
    func apply(@ESDiffableDataSourceSnapshotBuilder<SectionIdentifierType, ItemIdentifierType> _ snapshot: () -> ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) {
        apply(snapshot())
    }
}

#endif
