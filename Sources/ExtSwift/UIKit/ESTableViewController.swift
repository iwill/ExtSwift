//
//  ESTableViewController.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-20.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

open class ESTableViewController: UIViewController {
    
    open var tableViewStyle: UITableView.Style = .plain
    open var clearsSelectionOnViewWillAppear: Bool = true
    open private(set) var tableView: UITableView! // use `tableView.snp.removeAllConstraints()` to remove default constraints
    
    open var refreshControl: UIRefreshControl? {
        willSet {
            if refreshControl != nil {
                refreshControl!.removeFromSuperview()
            }
        }
        didSet {
            if refreshControl != nil {
                tableView.insertSubview(refreshControl!, at: 0)
            }
        }
    }
    
    public convenience init() {
        self.init(style: .plain)
    }
    public init(style: UITableView.Style) {
        tableViewStyle = style
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearsSelectionOnViewWillAppear {
            let indexPaths = tableView.indexPathsForSelectedRows ?? []
            for indexPath in indexPaths {
                tableView.deselectRow(at: indexPath, animated: animated)
            }
        }
    }
    
    private func loadTableView() {
        guard tableView == nil else {
            return
        }
        loadViewIfNeeded()
        
        tableView = UITableView(frame: view.bounds, style: tableViewStyle)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        if conforms(to: UITableViewDataSource.self) {
            tableView.dataSource = (self as! UITableViewDataSource)
        }
        if conforms(to: UITableViewDelegate.self) {
            tableView.delegate = (self as! UITableViewDelegate)
        }
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    deinit {
        tableView.dataSource = nil
        tableView.delegate = nil
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFLOAT_MIN
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFLOAT_MIN
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
