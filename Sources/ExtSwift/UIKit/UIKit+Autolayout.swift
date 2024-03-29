//
//  UIKit+Autolayout.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2020-12-29.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
public typealias UIScrollView = NSScrollView
public typealias UIViewController = NSViewController
public typealias UILayoutGuide = NSLayoutGuide
public class UILayoutSupport {}
#endif

// MARK: -

#if os(iOS) || os(tvOS) || os(macOS)

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

// MARK: -

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

// TODO: remove once NOT supporting iOS 11
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
