//
//  ESDiffableDataSourceSnapshot.swift
//  ExtSwift
//
//  Created by MingLQ on 2021-06-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#endif

/// #see NSDiffableDataSourceSnapshot

public struct ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    public private(set) var sectionIdentifiers: [SectionIdentifierType]
    public private(set) var allItemIdentifiers: [SectionIdentifierType: [ItemIdentifierType]]
    
    public init() {
        sectionIdentifiers = []
        allItemIdentifiers = [:]
    }
    
    public var numberOfSections: Int {
        return sectionIdentifiers.count
    }
    
    public func numberOfItems(inSection identifier: SectionIdentifierType) -> Int {
        return allItemIdentifiers[identifier]?.count ?? 0
    }
    
    public var numberOfItems: Int {
        return allItemIdentifiers.flatMap { (key: SectionIdentifierType, value: [ItemIdentifierType]) in
            return value
        }.count
    }
    
    public func sectionIdentifier(containingItem identifier: ItemIdentifierType) -> SectionIdentifierType? {
        for sectionIdentifier in sectionIdentifiers {
            if itemIdentifiers(inSection: sectionIdentifier).contains(identifier) {
                return sectionIdentifier
            }
        }
        return nil
    }
    
    public func itemIdentifiers(inSection identifier: SectionIdentifierType) -> [ItemIdentifierType] {
        return allItemIdentifiers[identifier] ?? []
    }
    
    public func indexOfSection(_ identifier: SectionIdentifierType) -> Int? {
        return sectionIdentifiers.firstIndex(of: identifier)
    }
    
    public func indexOfItem(_ identifier: ItemIdentifierType) -> Int? {
        return allItemIdentifiers.flatMap { (key: SectionIdentifierType, value: [ItemIdentifierType]) in
            return value
        }.firstIndex(of: identifier)
    }
}

public extension ESDiffableDataSourceSnapshot {
    
    mutating func appendItems(_ identifiers: [ItemIdentifierType], toSection sectionIdentifier: SectionIdentifierType? = nil) {
        guard let sectionIdentifier = sectionIdentifier ?? sectionIdentifiers.last else {
            return
        }
        var itemIdentifiers = allItemIdentifiers[sectionIdentifier] ?? []
        itemIdentifiers.append(contentsOf: identifiers)
        allItemIdentifiers[sectionIdentifier] = itemIdentifiers
    }
    
    mutating func insertItems(_ identifiers: [ItemIdentifierType], beforeItem beforeIdentifier: ItemIdentifierType) {
        guard let sectionIdentifier = sectionIdentifier(containingItem: beforeIdentifier),
              let beforeIndex = indexOfSection(sectionIdentifier) else {
            return
        }
        var itemIdentifiers = allItemIdentifiers[sectionIdentifier] ?? []
        itemIdentifiers.insert(contentsOf: identifiers, at: beforeIndex)
        allItemIdentifiers[sectionIdentifier] = itemIdentifiers
    }
    
    mutating func insertItems(_ identifiers: [ItemIdentifierType], afterItem afterIdentifier: ItemIdentifierType) {
        guard let sectionIdentifier = sectionIdentifier(containingItem: afterIdentifier),
              let afterIndex = indexOfSection(sectionIdentifier) else {
            return
        }
        var itemIdentifiers = allItemIdentifiers[sectionIdentifier] ?? []
        itemIdentifiers.insert(contentsOf: identifiers, at: afterIndex + 1)
        allItemIdentifiers[sectionIdentifier] = itemIdentifiers
    }
    
    mutating func deleteItems(_ identifiers: [ItemIdentifierType]) {
        for sectionIdentifier in sectionIdentifiers {
            guard var itemIdentifiers = allItemIdentifiers[sectionIdentifier] else {
                continue
            }
            itemIdentifiers.removeAll { identifiers.contains($0) }
            allItemIdentifiers[sectionIdentifier] = itemIdentifiers
        }
    }
    
    mutating func deleteAllItems() {
        sectionIdentifiers = []
        allItemIdentifiers = [:]
    }
    
    mutating func moveItem(_ identifier: ItemIdentifierType, beforeItem toIdentifier: ItemIdentifierType) {
        deleteItems([identifier])
        insertItems([identifier], beforeItem: toIdentifier)
    }
    
    mutating func moveItem(_ identifier: ItemIdentifierType, afterItem toIdentifier: ItemIdentifierType) {
        deleteItems([identifier])
        insertItems([identifier], afterItem: toIdentifier)
    }
    
    mutating func reloadItems(_ identifiers: [ItemIdentifierType]) {
    }
    
    mutating func appendSections(_ identifiers: [SectionIdentifierType]) {
        sectionIdentifiers.append(contentsOf: identifiers)
    }
    
    mutating func insertSections(_ identifiers: [SectionIdentifierType], beforeSection toIdentifier: SectionIdentifierType) {
        if let index = sectionIdentifiers.firstIndex(of: toIdentifier) {
            sectionIdentifiers.insert(contentsOf: identifiers, at: index)
        }
    }
    
    mutating func insertSections(_ identifiers: [SectionIdentifierType], afterSection toIdentifier: SectionIdentifierType) {
        if let index = sectionIdentifiers.firstIndex(of: toIdentifier) {
            sectionIdentifiers.insert(contentsOf: identifiers, at: index + 1)
        }
    }
    
    mutating func deleteSections(_ identifiers: [SectionIdentifierType]) {
        sectionIdentifiers.removeAll { identifiers.contains($0) }
    }
    
    mutating func moveSection(_ identifier: SectionIdentifierType, beforeSection toIdentifier: SectionIdentifierType) {
        deleteSections([identifier])
        insertSections([identifier], beforeSection: toIdentifier)
    }
    
    mutating func moveSection(_ identifier: SectionIdentifierType, afterSection toIdentifier: SectionIdentifierType) {
        deleteSections([identifier])
        insertSections([identifier], afterSection: toIdentifier)
    }
    
    mutating func reloadSections(_ identifiers: [SectionIdentifierType]) {
    }
}

#if os(iOS) || os(tvOS)

public extension ESDiffableDataSourceSnapshot {
    
    func sectionIdentifier(in section: Int) -> SectionIdentifierType? {
        return sectionIdentifiers[try: section]
    }
    
    func itemIdentifiers(in section: Int) -> [ItemIdentifierType] {
        guard let section = sectionIdentifiers[try: section] else {
            return []
        }
        return itemIdentifiers(inSection: section)
    }
    
    func itemIdentifier(at indexPath: IndexPath) -> ItemIdentifierType? {
        guard let section = sectionIdentifiers[try: indexPath.section] else {
            return nil
        }
        return itemIdentifiers(inSection: section)[try: indexPath.row]
    }
}

#endif
