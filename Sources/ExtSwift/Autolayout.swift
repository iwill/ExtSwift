//
//  Autolayout.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2020-12-29.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
public typealias UIResponder = NSResponder
public typealias UIView = NSView
public typealias UIScrollView = NSScrollView
public typealias UIViewController = NSViewController
public typealias UILayoutGuide = NSLayoutGuide
public class UILayoutSupport {}
#endif

extension UIResponder: ESNameSpace {}

public extension ES where Base: UIView {
    var safeAreaLayoutGuide: UILayoutGuide? {
        guard #available(iOS 11, macOS 11, *) else {
            return nil
        }
        return _base.safeAreaLayoutGuide
    }
}

#if os(iOS) || os(tvOS)

public extension ES where Base: UIScrollView {
    var contentLayoutGuide: UILayoutGuide? {
        guard #available(iOS 11, *) else {
            return nil
        }
        return _base.contentLayoutGuide
    }
    var frameLayoutGuide: UILayoutGuide? {
        guard #available(iOS 11, *) else {
            return nil
        }
        return _base.frameLayoutGuide
    }
}

public extension ES where Base: UIViewController {
    var topLayoutGuide: UILayoutSupport? {
        guard #available(iOS 11, *) else {
            return _base.topLayoutGuide
        }
        return nil // Use `view.safeAreaLayoutGuide.topAnchor` instead
    }
    var bottomLayoutGuide: UILayoutSupport? {
        guard #available(iOS 11, *) else {
            return _base.bottomLayoutGuide
        }
        return nil // Use `view.safeAreaLayoutGuide.bottomAnchor` instead
    }
}

#endif
