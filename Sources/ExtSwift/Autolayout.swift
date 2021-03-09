//
//  Autolayout.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2020-12-29.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS) || os(macOS)

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
        if #available(iOS 11, tvOS 11, macOS 11, *) {
            return _base.safeAreaLayoutGuide
        }
        return nil
    }
}

#endif

#if os(iOS) || os(tvOS)

public extension ES where Base: UIScrollView {
    var contentLayoutGuide: UILayoutGuide? {
        if #available(iOS 11, tvOS 11, *) {
            return _base.contentLayoutGuide
        }
        return nil
    }
    var frameLayoutGuide: UILayoutGuide? {
        if #available(iOS 11, tvOS 11, *) {
            return _base.frameLayoutGuide
        }
        return nil
    }
}

public extension ES where Base: UIViewController {
    var topLayoutGuide: UILayoutSupport? {
#if targetEnvironment(macCatalyst)
        return nil
#else
        if #available(iOS 11, tvOS 11, *) {
            return nil // Use `view.safeAreaLayoutGuide.topAnchor` instead
        }
        return _base.topLayoutGuide
#endif
    }
    var bottomLayoutGuide: UILayoutSupport? {
#if targetEnvironment(macCatalyst)
        return nil
#else
        if #available(iOS 11, tvOS 11, *) {
            return nil // Use `view.safeAreaLayoutGuide.bottomAnchor` instead
        }
        return _base.bottomLayoutGuide
#endif
    }
}

#endif
