//
//  ESDiffableDataSourceSnapshotBuilder.swift
//  ExtSwift
//
//  Created by Míng on 2021-06-09.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

// for [SectionWithItems]
@resultBuilder
public struct ESDiffableDataSourceSnapshotBuilder<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    public typealias SectionWithItems = (SectionIdentifierType?, [ItemIdentifierType])
    
    public static func buildBlock(_ components: [SectionWithItems]...) -> [SectionWithItems] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ components: [SectionWithItems]?) -> [SectionWithItems] {
        return components ?? []
    }
    
    public static func buildEither(first components: [SectionWithItems]) -> [SectionWithItems] {
        return components
    }
    
    public static func buildEither(second components: [SectionWithItems]) -> [SectionWithItems] {
        return components
    }
    
    public static func buildArray(_ components: [[SectionWithItems]]) -> [SectionWithItems] {
        return components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: SectionWithItems) -> [SectionWithItems] {
        return [expression]
    }
    
    public static func buildExpression(_ expression: [SectionWithItems]) -> [SectionWithItems] {
        return [expression].flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: SectionIdentifierType) -> [SectionWithItems] {
        if expression is [SectionIdentifierType] {
            return (expression as! [SectionIdentifierType]).map { ($0, []) } // `as! [SectionIdentifierType]` for `AnyHashable`
        }
        return [(expression, [])]
    }
    
    public static func buildExpression(_ expression: [SectionIdentifierType]) -> [SectionWithItems] {
        return expression.map { ($0, []) }
    }
    
    public static func buildExpression(_ expression: ItemIdentifierType) -> [SectionWithItems] {
        return [(nil, expression as? [ItemIdentifierType] ?? [expression])] // `as? [ItemIdentifierType]` for `AnyHashable`
    }
    
    public static func buildExpression(_ expression: [ItemIdentifierType]) -> [SectionWithItems] {
        return [(nil, expression)]
    }
    
    public static func buildFinalResult(_ components: [SectionWithItems]) -> ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        var snapshot = ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        for (section, items) in components {
            if section != nil {
                snapshot.appendSections([section!])
            }
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    public static func buildFinalResult(_ components: [SectionWithItems]) -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
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
@resultBuilder
public struct ESDiffableDataSourceItemIdentifierBuilder<ItemIdentifierType> where ItemIdentifierType: Hashable {
    
    public static func buildBlock(_ components: [ItemIdentifierType]...) -> [ItemIdentifierType] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ components: [ItemIdentifierType]?) -> [ItemIdentifierType] {
        return components ?? []
    }
    
    public static func buildEither(first components: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return components
    }
    
    public static func buildEither(second components: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return components
    }
    
    public static func buildArray(_ components: [[ItemIdentifierType]]) -> [ItemIdentifierType] {
        return components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: ItemIdentifierType) -> [ItemIdentifierType] {
        return expression as? [ItemIdentifierType] ?? [expression] // `as? [ItemIdentifierType]` for `AnyHashable`
    }
    
    public static func buildExpression(_ expression: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return expression
    }
    
    public static func buildFinalResult(_ components: [ItemIdentifierType]) -> [ItemIdentifierType] {
        return components
    }
}

// MARK: -

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

public extension UICollectionViewDiffableDataSource {
    func apply(@ESDiffableDataSourceSnapshotBuilder<SectionIdentifierType, ItemIdentifierType> snapshot: () -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) {
        apply(snapshot())
    }
}

public extension UITableViewDiffableDataSource {
    func apply(@ESDiffableDataSourceSnapshotBuilder<SectionIdentifierType, ItemIdentifierType> snapshot: () -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) {
        apply(snapshot())
    }
}
