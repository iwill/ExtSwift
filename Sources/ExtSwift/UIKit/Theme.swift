//
//  Theme.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-14.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

private class ThemeMakerWrapper: Equatable {
    
    let closure: () -> Void
    
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    static func == (lhs: ThemeMakerWrapper, rhs: ThemeMakerWrapper) -> Bool {
        return lhs === rhs
    }
}

private var AssociatedObject_theme: UInt8 = 0
private var AssociatedObject_themeMakers: UInt8 = 0

/// UIResponder: UIApplication, UIWindowScene, UIWindow, UIViewController, UIView, UIControl ...
public extension UIResponder {
    
    @available(iOS, introduced: 13.0, deprecated: 17.0, message: "Use `UITraitDefinition` insead: https://developer.apple.com/videos/play/wwdc2023/10057/")
    var theme: String? {
        get {
            let string = objc_getAssociatedObject(self, &AssociatedObject_theme) as? String
            return string ?? next?.theme
        }
        set {
            let prevTheme = theme
            guard newValue != prevTheme else { return }
            objc_setAssociatedObject(self, &AssociatedObject_theme, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateTheme(prevTheme: prevTheme)
        }
    }
    
    private var themeMakers: [ThemeMakerWrapper]? {
        get {
            let themeMakers = objc_getAssociatedObject(self, &AssociatedObject_themeMakers)
            return themeMakers as? [ThemeMakerWrapper]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObject_themeMakers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate func updateTheme(prevTheme: String?) {
        for wrapper in themeMakers ?? [] {
            wrapper.closure()
        }
        if let view = self as? UIView {
            for subview in view.subviews {
                subview.updateTheme(prevTheme: prevTheme)
            }
        }
    }
    
    /// makers will be called when:
    /// 1. responder.makeTheme(:)
    /// 2. view[...superview] didMoveToSuperview()
    /// 3. view[...nextResponder] setTheme(:)
    @discardableResult
    func makeTheme(_ maker: @escaping (Self) -> Void) -> any Equatable {
        maker(self as! Self)
        
        // !!!: new closure to erase `Base` type from `ThemeMakerWrapper`
        let wrapper = ThemeMakerWrapper { [weak self] in
            if self != nil {
                maker(self as! Self)
            }
        }
        
        var themeMakers = themeMakers ?? []
        themeMakers.append(wrapper)
        
        self.themeMakers = themeMakers
        
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
        var themeMakers = themeMakers
        themeMakers?.removeAll(where: { wrapper in
            return wrapper == receipt as? ThemeMakerWrapper
        })
        self.themeMakers = themeMakers
    }
    
    func removeThemes() {
        var themeMakers = themeMakers
        themeMakers?.removeAll()
        self.themeMakers = themeMakers
    }
}

// MARK: swizzle `UIView.didMoveToSuperview()`

public extension UIView {
    
    @objc func _es_didMoveToSuperview() {
        _es_didMoveToSuperview()
        updateTheme(prevTheme: nil)
    }
    
    static func autoUpdateThemeWhenMovedToSuperview() {
        guard let originalMethod = class_getInstanceMethod(Self.self, #selector(didMoveToSuperview)),
              let swizzledMethod = class_getInstanceMethod(Self.self, #selector(_es_didMoveToSuperview)) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
