//
//  ESTableViewDiffableDataSource.swift
//  ExtSwift
//
//  Created by Míng on 2021-06-09.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

/// #see UITableViewDiffableDataSource

public extension UITableView {
    
    struct ESCellRegistration<Cell, Item> where Cell: UITableViewCell, Item: Hashable {
        public typealias Handler = (_ cell: Cell, _ indexPath: IndexPath, _ item: Item) -> Void
        fileprivate let reuseIdentifier: String
        fileprivate let handler: Handler
        public init(_reuseIdentifier: String = UUID().uuidString, handler: @escaping Handler) {
            self.reuseIdentifier = _reuseIdentifier
            self.handler = handler
        }
    }
    
    func dequeueConfiguredReusableCell<Cell, Item>(using registration: ESCellRegistration<Cell, Item>, for indexPath: IndexPath, item: Item?) -> Cell where Cell: UITableViewCell {
        guard let item = item else { return Cell() }
        if dequeueReusableCell(withIdentifier: registration.reuseIdentifier) == nil {
            register(Cell.self, forCellReuseIdentifier: registration.reuseIdentifier)
        }
        let cell = dequeueReusableCell(withIdentifier: registration.reuseIdentifier, for: indexPath) as! Cell
        registration.handler(cell, indexPath, item)
        return cell
    }
}

open class ESTableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>: NSObject, UITableViewDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    public typealias CellProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UITableViewCell?
    public typealias StringProvider = (_ tableView: UITableView, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> String?
    public typealias ViewProvider = (_ tableView: UITableView, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> UIView?
    
    private let tableView: UITableView
    private let cellProvider: CellProvider
    private let headerTitleProvider: StringProvider?
    private let headerViewProvider: ViewProvider?
    private let footerTitleProvider: StringProvider?
    private let footerViewProvider: ViewProvider?
    private lazy var _snapshot = ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
    
    public init(tableView: UITableView, cellProvider: @escaping CellProvider, headerTitleProvider: StringProvider? = nil, headerViewProvider: ViewProvider? = nil, footerTitleProvider: StringProvider? = nil, footerViewProvider: ViewProvider? = nil) {
        self.tableView = tableView
        self.cellProvider = cellProvider
        self.headerTitleProvider = headerTitleProvider
        self.headerViewProvider = headerViewProvider
        self.footerTitleProvider = footerTitleProvider
        self.footerViewProvider = footerViewProvider
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: indexPath.section],
           let itemIdentifier = _snapshot.allItemIdentifiers[sectionIdentifier]![try: indexPath.row],
           let cell = cellProvider(tableView, indexPath, itemIdentifier) {
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let title = headerTitleProvider?(tableView, section, sectionIdentifier) {
            return title
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let view = headerViewProvider?(tableView, section, sectionIdentifier) {
            return view
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let title = footerTitleProvider?(tableView, section, sectionIdentifier) {
            return title
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let view = footerViewProvider?(tableView, section, sectionIdentifier) {
            return view
        }
        return nil
    }
}
