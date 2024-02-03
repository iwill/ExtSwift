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
    
    struct ESCellRegistration<Cell, ItemIdentifierType> where Cell: UITableViewCell, ItemIdentifierType: Hashable {
        public typealias Handler = (_ cell: Cell, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> Void
        fileprivate let reuseIdentifier: String
        fileprivate let handler: Handler
        public init(_reuseIdentifier: String = "\(Cell.self)-\(ItemIdentifierType.self)-\(UUID().uuidString)", handler: @escaping Handler) {
            self.reuseIdentifier = _reuseIdentifier
            self.handler = handler
        }
    }
    
    func dequeueConfiguredReusableCell<Cell, ItemIdentifierType>(using registration: ESCellRegistration<Cell, ItemIdentifierType>, for indexPath: IndexPath, itemIdentifier: ItemIdentifierType?) -> Cell where Cell: UITableViewCell {
        guard let itemIdentifier else { return Cell() }
        if dequeueReusableCell(withIdentifier: registration.reuseIdentifier) == nil {
            register(Cell.self, forCellReuseIdentifier: registration.reuseIdentifier)
        }
        let cell = dequeueReusableCell(withIdentifier: registration.reuseIdentifier, for: indexPath) as! Cell
        registration.handler(cell, indexPath, itemIdentifier)
        return cell
    }
    
    struct ESHeaderFooterRegistration<HeaderFooter, SectionIdentifierType> where HeaderFooter: UITableViewHeaderFooterView, SectionIdentifierType: Hashable {
        public typealias Handler = (_ headerFooter: HeaderFooter, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> Void
        fileprivate let reuseIdentifier: String
        fileprivate let handler: Handler
        public init(_reuseIdentifier: String = "\(HeaderFooter.self)-\(SectionIdentifierType.self)-\(UUID().uuidString)", handler: @escaping Handler) {
            self.reuseIdentifier = _reuseIdentifier
            self.handler = handler
        }
    }
    
    func dequeueConfiguredReusableHeaderFooter<HeaderFooter, SectionIdentifierType>(using registration: ESHeaderFooterRegistration<HeaderFooter, SectionIdentifierType>, section: Int, sectionIdentifier: SectionIdentifierType?) -> HeaderFooter where HeaderFooter: UITableViewHeaderFooterView {
        guard let sectionIdentifier else { return HeaderFooter() }
        var headerFooter = dequeueReusableHeaderFooterView(withIdentifier: registration.reuseIdentifier) as? HeaderFooter
        if !?headerFooter {
            register(HeaderFooter.self, forHeaderFooterViewReuseIdentifier: registration.reuseIdentifier)
            headerFooter = dequeueReusableHeaderFooterView(withIdentifier: registration.reuseIdentifier) as? HeaderFooter
        }
        registration.handler(headerFooter!, section, sectionIdentifier)
        return headerFooter!
    }
}

open class ESTableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>: NSObject, UITableViewDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    public typealias CellProvider = (_ tableView: UITableView, _ indexPath: IndexPath, _ itemIdentifier: ItemIdentifierType) -> UITableViewCell?
    
    public typealias StringProvider = (_ tableView: UITableView, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> String?
    public typealias ViewProvider = (_ tableView: UITableView, _ section: Int, _ sectionIdentifier: SectionIdentifierType) -> UITableViewHeaderFooterView?
    
    private let tableView: UITableView
    private let cellProvider: CellProvider,
                headerTitleProvider: StringProvider?,
                footerTitleProvider: StringProvider?,
                headerViewProvider: ViewProvider?,
                footerViewProvider: ViewProvider?
    private lazy var _snapshot = ESDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
    
    public init(tableView: UITableView,
                cellProvider: @escaping CellProvider,
                headerTitleProvider: StringProvider? = nil,
                footerTitleProvider: StringProvider? = nil,
                headerViewProvider: ViewProvider? = nil,
                footerViewProvider: ViewProvider? = nil) {
        self.tableView = tableView
        self.cellProvider = cellProvider
        self.headerTitleProvider = headerTitleProvider
        self.footerTitleProvider = footerTitleProvider
        self.headerViewProvider = headerViewProvider
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
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let title = footerTitleProvider?(tableView, section, sectionIdentifier) {
            return title
        }
        return nil
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionIdentifier = _snapshot.sectionIdentifiers[try: section],
           let view = headerViewProvider?(tableView, section, sectionIdentifier) {
            return view
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
