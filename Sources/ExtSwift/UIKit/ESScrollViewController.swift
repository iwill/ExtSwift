//
//  ESScrollViewController.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-19.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

fileprivate class ESScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        guard let delegate = delegate as? ESScrollViewDelegate else {
            return super.touchesShouldCancel(in: view)
        }
        return delegate.scrollView(self, touchesShouldCancelIn: view, default: super.touchesShouldCancel(in: view))
    }
}

@objc public protocol ESScrollViewDelegate: UIScrollViewDelegate {
    func scrollView(_ scrollView: UIScrollView, touchesShouldCancelIn view: UIView, default: Bool) -> Bool
}

open class ESScrollViewController: UIViewController {
    open private(set) var scrollView: UIScrollView! // use `scrollView.snp.removeAllConstraints()` to remove default constraints
    open var refreshControl: UIRefreshControl? {
        willSet {
            if refreshControl != nil {
                refreshControl!.removeFromSuperview()
            }
        }
        didSet {
            if refreshControl != nil {
                scrollView.insertSubview(refreshControl!, at: 0)
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        loadScrollView()
    }
    
    private func loadScrollView() {
        guard scrollView == nil else {
            return
        }
        loadViewIfNeeded()
        
        scrollView = ESScrollView(frame: view.bounds)
        scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.always
        if conforms(to: UIScrollViewDelegate.self) {
            scrollView.delegate = (self as! UIScrollViewDelegate)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    deinit {
        scrollView.delegate = nil
    }
}
