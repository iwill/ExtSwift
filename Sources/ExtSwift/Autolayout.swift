//
//  Autolayout.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2020-12-29.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

#if os(iOS) // || os(tvOS)

import UIKit

extension UIResponder: ESNameSpace {}

public extension ES where Base: UIView {
    var safeAreaLayoutGuide: UILayoutGuide? {
        guard #available(iOS 11, *) else {
            return nil
        }
        return _base.safeAreaLayoutGuide
    }
}

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

// #if os(macOS)
// import AppKit
// public typealias UIResponder = NSResponder
// public typealias UIView = NSView
// public typealias UILayoutGuide = NSLayoutGuide
// public class UILayoutSupport {}
// #endif
