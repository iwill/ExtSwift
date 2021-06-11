//
//  ESCollectionViewDiffableDataSource.swift
//  ExtSwift
//
//  Created by MingLQ on 2021-06-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)

import UIKit

/// #see UICollectionViewDiffableDataSource

public extension UICollectionView {
    
    struct ESCellRegistration<Cell, Item> where Cell: UICollectionViewCell, Item: Hashable {
        public typealias Handler = (_ cell: Cell, _ indexPath: IndexPath, _ item: Item) -> Void
        fileprivate let reuseIdentifier = UUID().uuidString
        fileprivate let handler: Handler
        public init(handler: @escaping Handler) {
            self.handler = handler
        }
    }
    
    func dequeueConfiguredReusableCell<Cell, Item>(using registration: ESCellRegistration<Cell, Item>, for indexPath: IndexPath, item: Item?) -> Cell where Cell: UICollectionViewCell {
        guard let item = item else { return Cell() }
        register(Cell.self, forCellWithReuseIdentifier: registration.reuseIdentifier)
        let cell = dequeueReusableCell(withReuseIdentifier: registration.reuseIdentifier, for: indexPath) as! Cell
        registration.handler(cell, indexPath, item)
        return cell
    }
}

public extension UICollectionView {
    
    struct ESSupplementaryRegistration<Supplementary, Section> where Supplementary: UICollectionReusableView, Section: Hashable {
        public typealias Handler = (_ supplementary: Supplementary, _ elementKind: String, _ indexPath: IndexPath, _ section: Section) -> Void
        fileprivate let elementKind: String
        fileprivate let reuseIdentifier = UUID().uuidString
        fileprivate let handler: Handler
        public init(elementKind: String, handler: @escaping Handler) {
            self.elementKind = elementKind
            self.handler = handler
        }
    }
    
    func dequeueConfiguredReusableSupplementary<Supplementary, Section>(using registration: ESSupplementaryRegistration<Supplementary, Section>, for indexPath: IndexPath, section: Section?) -> Supplementary where Supplementary: UICollectionReusableView {
        guard let section = section else { return Supplementary() }
        register(Supplementary.self, forSupplementaryViewOfKind: registration.elementKind, withReuseIdentifier: registration.reuseIdentifier)
        let supplementary = dequeueReusableSupplementaryView(ofKind: registration.elementKind, withReuseIdentifier: registration.reuseIdentifier, for: indexPath) as! Supplementary
        registration.handler(supplementary, registration.elementKind, indexPath, section)
        return supplementary
    }
}

open class ESCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>: NSObject, UICollectionViewDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    public typealias CellProvider = (_ collectionView: UICollectionView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UICollectionViewCell?
    public typealias SupplementaryViewProvider = (_ collectionView: UICollectionView, _ elementKind: String, _ indexPath: IndexPath, _ sectionIdentifier: SectionIdentifierType) -> UICollectionReusableView?
    
    private let collectionView: UICollectionView
    private let cellProvider: CellProvider
    public var supplementaryViewProvider: SupplementaryViewProvider?
    private lazy var _snapshot = ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
    
    public init(collectionView: UICollectionView, cellProvider: @escaping CellProvider, supplementaryViewProvider: SupplementaryViewProvider? = nil) {
        self.collectionView = collectionView
        self.cellProvider = cellProvider
        self.supplementaryViewProvider = supplementaryViewProvider
        super.init()
        collectionView.dataSource = self
    }
    
    open func snapshot() -> ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        return _snapshot 
    }
    
    open func apply(_ snapshot: ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) { // , animatingDifferences: Bool = true, completion: (() -> Void)? = nil
        _snapshot = snapshot
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _snapshot.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _snapshot.numberOfItems(in: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemIdentifier = _snapshot.itemIdentifier(at: indexPath),
           let cell = cellProvider(collectionView, indexPath, itemIdentifier) {
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind elementKind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionIdentifier = _snapshot.sectionIdentifier(in: indexPath.section),
           let supplementary = supplementaryViewProvider?(collectionView, elementKind, indexPath, sectionIdentifier) {
            return supplementary
        }
        return UICollectionReusableView()
    }
}

#endif
