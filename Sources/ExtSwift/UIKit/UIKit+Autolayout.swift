//
//  UIKit+Autolayout.swift
//  ExtSwift
//
//  Created by Míng on 2020-12-29.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

// MARK: -

public extension ES where Base: UIView {
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use `view.safeAreaLayoutGuide` instead")
    var safeAreaLayoutGuide: UILayoutGuide? {
        if #available(iOS 11, tvOS 11, macOS 11, *) {
            return _base.safeAreaLayoutGuide
        }
        return nil
    }
}

// MARK: -

public extension ES where Base: UIScrollView {
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use `view.contentLayoutGuide` instead")
    var contentLayoutGuide: UILayoutGuide? {
        if #available(iOS 11, tvOS 11, *) {
            return _base.contentLayoutGuide
        }
        return nil
    }
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use `view.frameLayoutGuide` instead")
    var frameLayoutGuide: UILayoutGuide? {
        if #available(iOS 11, tvOS 11, *) {
            return _base.frameLayoutGuide
        }
        return nil
    }
}

// TODO: remove once NOT supporting iOS 11
public extension ES where Base: UIViewController {
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use `view.safeAreaLayoutGuide` instead")
    var topLayoutGuide: UILayoutSupport? {
        if #available(iOS 11, tvOS 11, *) {
            return nil // Use `view.safeAreaLayoutGuide.topAnchor` instead
        }
        return _base.topLayoutGuide
    }
    @available(iOS, introduced: 7.0, deprecated: 11.0, message: "Use `view.safeAreaLayoutGuide` instead")
    var bottomLayoutGuide: UILayoutSupport? {
        if #available(iOS 11, tvOS 11, *) {
            return nil // Use `view.safeAreaLayoutGuide.bottomAnchor` instead
        }
        return _base.bottomLayoutGuide
    }
}
