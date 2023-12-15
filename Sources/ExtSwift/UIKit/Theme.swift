//
//  Theme.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-14.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)

import UIKit

private var AssociatedObject_theme: UInt8 = 0
private var AssociatedObject_themeMakers: UInt8 = 0

private class ThemeMakerWrapper: Equatable {
    
    let maker: (UIResponder) -> Void
    
    init(_ maker: @escaping (UIResponder) -> Void) {
        self.maker = maker
    }
    
    static func == (lhs: ThemeMakerWrapper, rhs: ThemeMakerWrapper) -> Bool {
        return lhs === rhs
    }
}

/// UIResponder: UIApplication, UIWindowScene, UIWindow, UIViewController, UIView, UIControl ...
public extension ES where Base: UIResponder {
    
    var theme: String? {
        get {
            let string = objc_getAssociatedObject(_base, &AssociatedObject_theme) as? String
            return string ?? _base.next?.es.theme
        }
        set {
            let prevTheme = theme
            guard newValue != prevTheme else {
                return
            }
            objc_setAssociatedObject(_base, &AssociatedObject_theme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateTheme(prevTheme: prevTheme)
        }
    }
    
    private var themeMakers: NSMutableArray? {
        get {
            let themeMakers = objc_getAssociatedObject(_base, &AssociatedObject_themeMakers)
            return themeMakers as? NSMutableArray
        }
        set {
            objc_setAssociatedObject(_base, &AssociatedObject_themeMakers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func updateTheme(prevTheme: String?) {
        for wrapper in themeMakers ?? NSMutableArray() {
            if let wrapper = wrapper as? ThemeMakerWrapper {
                wrapper.maker(_base)
            }
        }
        if let view = _base as? UIView {
            for subview in view.subviews {
                subview.es.updateTheme(prevTheme: prevTheme)
            }
        }
    }
    
    /// makers will be called when:
    /// 1. responder.makeTheme(:)
    /// 2. view[...superview] didMoveToSuperview()
    /// 3. view[...nextResponder] setTheme(:)
    @discardableResult
    func makeTheme(_ maker: @escaping (UIResponder) -> Void) -> any Equatable {
        maker(_base)
        let wrapper = ThemeMakerWrapper(maker)
        
        let themeMakers = themeMakers ?? NSMutableArray()
        themeMakers.add(wrapper)
        
        var this = self
        this.themeMakers = themeMakers
        
        return wrapper
    }
    
    @discardableResult
    func replaceTheme(receipt: any Equatable, _ maker: @escaping (UIResponder) -> Void) -> any Equatable {
        removeTheme(receipt: receipt)
        return makeTheme(maker)
    }
    
    @discardableResult
    func remakeTheme(_ maker: @escaping (UIResponder) -> Void) -> any Equatable {
        removeThemes()
        return makeTheme(maker)
    }
    
    func removeTheme(receipt: any Equatable) {
        themeMakers?.remove(receipt)
        var this = self
        this.themeMakers = themeMakers
    }
    
    func removeThemes() {
        themeMakers?.removeAllObjects()
        var this = self
        this.themeMakers = themeMakers
    }
}

// MARK: swizzle `UIView.didMoveToSuperview()`

public extension UIView {
    @objc func _es_didMoveToSuperview() {
        _es_didMoveToSuperview()
        es.updateTheme(prevTheme: nil)
    }
}

public extension ES where Base: UIView {
    static func autoUpdateThemeWhenMovedToSuperview() {
        guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(UIView.didMoveToSuperview)),
              let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(UIView._es_didMoveToSuperview))
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

#elseif os(macOS)
import AppKit
public typealias UIApplication = NSApplication
public typealias UIApplicationDelegate = NSApplicationDelegate
// public typealias UIWindowSceneDelegate = NSWindowSceneDelegate
#endif
