//
//  Theme.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-14.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)

import UIKit

public extension UIApplicationDelegate {
    func application(_ application: UIApplication, didUpdateTheme prevTheme: String?) {}
}

@available(iOS 13.0, *)
public extension UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, didUpdateTheme prevTheme: String?) {}
}

// MARK: TODO: name space

private var AssociatedObject_theme: UInt8 = 0
private var AssociatedObject_prevTheme: UInt8 = 0
private var AssociatedObject_themeMakers: UInt8 = 0

public extension ES where Base: UIResponder {
    
    var theme: String? {
        
        get {
            let string = objc_getAssociatedObject(_base, &AssociatedObject_theme) as? String
            return string ?? _base.next?.es.theme
        }
        
        /// 1. theme = newValue
        /// 2. themeDidUpdate()
        /// 3. updateTheme()
        set {
            let prevTheme = theme
            guard newValue != prevTheme else {
                return
            }
            objc_setAssociatedObject(_base, &AssociatedObject_theme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if let view = _base as? UIView {
                // `view.themeDidUpdate()` will be called in `view.updateTheme()`
                view.es.updateTheme()
            }
            
            if let viewController = _base as? UIViewController {
                // `viewController.themeDidUpdate()` will be called in `view.updateTheme`
                viewController.view.es.updateTheme()
            }
            
            if var app = _base as? UIApplication {
                
                if theme != app.es.prevTheme {
                    app.es.themeDidUpdate(app.es.prevTheme)
                    app.delegate?.application(app, didUpdateTheme: app.es.prevTheme)
                    app.es.prevTheme = app.es.theme
                }
                
                if #available(iOS 13, *) {
                    for scene in app.connectedScenes {
                        if let windowScene = scene as? UIWindowScene {
                            for window in windowScene.windows {
                                window.es.updateTheme()
                            }
                        }
                    }
                }
                else {
                    for window in app.windows {
                        window.es.updateTheme()
                    }
                }
            }
            
            if #available(iOS 13, *) {
                if var windowScene = _base as? UIWindowScene {
                    if theme != windowScene.es.prevTheme {
                        windowScene.es.themeDidUpdate(windowScene.es.prevTheme)
                        (windowScene.delegate as? UIWindowSceneDelegate)?.windowScene(windowScene, didUpdateTheme: windowScene.es.prevTheme)
                        windowScene.es.prevTheme = theme
                    }
                    for window in windowScene.windows {
                        window.es.updateTheme()
                    }
                }
            }
        }
    }
    
    fileprivate var prevTheme: String? {
        get {
            return objc_getAssociatedObject(_base, &AssociatedObject_prevTheme) as? String
        }
        set {
            objc_setAssociatedObject(_base, &AssociatedObject_prevTheme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // requires calling super when override
    func themeDidUpdate(_ prevTheme: String?) {
    }
}

public extension UIView {
    @objc func _es_didMoveToSuperview() {
        _es_didMoveToSuperview()
        es.updateTheme()
    }
}

public extension ES where Base: UIView {
    
    typealias ThemeMaker = (UIView) -> Void
    
    private class ThemeMakerWrapper: Equatable {
        let maker: ThemeMaker
        init(_ maker: @escaping ThemeMaker) {
            self.maker = maker
        }
        static func == (lhs: ThemeMakerWrapper, rhs: ThemeMakerWrapper) -> Bool {
            return lhs === rhs
        }
    }
    
    /// swizzle `UIView.didMoveToSuperview()`
    static func autoUpdateThemeWhenMovedToSuperview() {
        guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(UIView.didMoveToSuperview)),
              let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(UIView._es_didMoveToSuperview))
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    fileprivate func updateTheme() {
        /// 1. viewController.themeDidUpdate()
        if var viewController = _base.next as? UIViewController,
           viewController.es.theme != viewController.es.prevTheme {
            viewController.es.themeDidUpdate(viewController.es.prevTheme)
            viewController.es.prevTheme = viewController.es.theme
        }
        
        /// 2. view.themeDidUpdate()
        guard theme != prevTheme else {
            return
        }
        themeDidUpdate(prevTheme)
        var this = self
        this.prevTheme = theme
        
        /// 3. maker(self)
        for wrapper in themeMakers ?? [] {
            wrapper.maker(_base)
        }
        
        /// 4. subview.updateTheme()
        for subview in _base.subviews {
            subview.es.updateTheme()
        }
    }
    
    private var themeMakers: [ThemeMakerWrapper]? {
        get {
            return objc_getAssociatedObject(_base, &AssociatedObject_themeMakers) as? [ThemeMakerWrapper]
        }
        set {
            objc_setAssociatedObject(_base, &AssociatedObject_themeMakers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// makers will be called when:
    /// 1. view.bjl.make(theme:)
    /// 2. view[...nextResponder] didMoveToSuperview()
    /// 3. view[...nextResponder] setTheme(:)
    @discardableResult
    func makeTheme(_ maker: @escaping ThemeMaker) -> any Equatable {
        let wrapper = ThemeMakerWrapper(maker)
        
        var themeMakers = themeMakers ?? []
        themeMakers.append(wrapper)
        var this = self
        this.themeMakers = themeMakers
        
        maker(_base)
        return wrapper
    }
    
    @discardableResult
    func replaceTheme(receipt: any Equatable, _ maker: @escaping ThemeMaker) -> any Equatable {
        removeTheme(receipt: receipt)
        return makeTheme(maker)
    }
    
    @discardableResult
    func remakeTheme(_ maker: @escaping ThemeMaker) -> any Equatable {
        removeThemes()
        return makeTheme(maker)
    }
    
    func removeTheme(receipt: any Equatable) {
        var themeMakers = themeMakers
        themeMakers?.removeAll(where: { wrapper in
            return wrapper == receipt as? ThemeMakerWrapper
        })
        var this = self
        this.themeMakers = themeMakers
    }
    
    func removeThemes() {
        var themeMakers = themeMakers
        themeMakers?.removeAll()
        var this = self
        this.themeMakers = themeMakers
    }
}

#elseif os(macOS)
import AppKit
public typealias UIApplication = NSApplication
public typealias UIApplicationDelegate = NSApplicationDelegate
// public typealias UIWindowSceneDelegate = NSWindowSceneDelegate
#endif
