//
//  ESTableViewDiffableDataSource.swift
//  ExtSwift
//
//  Created by MingLQ on 2021-06-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)

import UIKit

/// #see UITableViewDiffableDataSource

public extension UITableView {
    
    struct ESCellRegistration<Cell, Item> where Cell: UITableViewCell, Item: Hashable {
        public typealias Handler = (_ cell: Cell, _ indexPath: IndexPath, _ item: Item) -> Void
        fileprivate let reuseIdentifier: String
        fileprivate let handler: Handler
        fileprivate init(reuseIdentifier: String, handler: @escaping Handler) {
            self.reuseIdentifier = reuseIdentifier
            self.handler = handler
        }
    }
    
    func cellRegistration<Cell, Item>(cellClass: AnyClass?, handler: @escaping ESCellRegistration<Cell, Item>.Handler) -> ESCellRegistration<Cell, Item> {
        let identifier = UUID().uuidString
        register(cellClass, forCellReuseIdentifier: identifier)
        return ESCellRegistration(reuseIdentifier: identifier, handler: handler)
    }
    
    func dequeueConfiguredReusableCell<Cell, Item>(using registration: ESCellRegistration<Cell, Item>, for indexPath: IndexPath, item: Item?) -> Cell where Cell: UITableViewCell {
        guard let item = item else { return Cell() }
        let cell = dequeueReusableCell(withIdentifier: registration.reuseIdentifier, for: indexPath) as! Cell
        registration.handler(cell, indexPath, item)
        return cell
    }
}

open class ESTableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>: NSObject, UITableViewDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    public typealias TitleProvider = (_ tableView: UITableView, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> String?
    public typealias HeaderViewProvider = (_ tableView: UITableView, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> UIView?
    public typealias CellProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UITableViewCell?
    
    private let tableView: UITableView
    private let titleProvider: TitleProvider?
    private let headerViewProvider: HeaderViewProvider?
    private let cellProvider: CellProvider
    private lazy var _snapshot = ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
    
    public init(tableView: UITableView, titleProvider: TitleProvider? = nil, headerViewProvider: HeaderViewProvider? = nil, cellProvider: @escaping CellProvider) {
        self.tableView = tableView
        self.titleProvider = titleProvider
        self.headerViewProvider = headerViewProvider
        self.cellProvider = cellProvider
        super.init()
        tableView.dataSource = self
    }
    
    open func snapshot() -> ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        return _snapshot 
    }
    
    open func apply(_ snapshot: ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>) { // , animatingDifferences: Bool = true, completion: (() -> Void)? = nil
        _snapshot = snapshot
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return _snapshot.numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _snapshot.numberOfItems(inSection: _snapshot.sectionIdentifiers[section])
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let title = titleProvider?(tableView, section, sectionIdentifier) {
            return title
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: indexPath.section],
           let itemIdentifier = _snapshot.allItemIdentifiers[sectionIdentifier]![try: indexPath.row],
           let cell = cellProvider(tableView, indexPath, itemIdentifier) {
            return cell
        }
        return UITableViewCell()
    }
}

#endif
