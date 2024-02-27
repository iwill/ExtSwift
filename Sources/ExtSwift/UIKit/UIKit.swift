//
//  UIKit.swift
//  ExtSwift
//
//  Created by Míng on 2021-04-20.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

/// - seealso: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
infix operator |: AdditionPrecedence

// MARK: AttributedString
// https://stackoverflow.com/a/68156160/456536

public extension String {
    static func | (string: String, attributes: AttributeContainer? = nil) -> AttributedString {
        return AttributedString(string, attributes: attributes ?? AttributeContainer())
    }
    static func | (string: String, attributes: [NSAttributedString.Key: Any]? = nil) -> AttributedString {
        return AttributedString(string, attributes: AttributeContainer(attributes ?? [:]))
    }
    static func | (string: String, attributes: AttributeContainer? = nil) -> NSAttributedString {
        return NSAttributedString(AttributedString(string, attributes: attributes ?? AttributeContainer()))
    }
    static func | (string: String, attributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes ?? [:])
    }
}

public protocol OptionalAttributedText: AnyObject {
    var attributedText: NSAttributedString? { get set }
    var attributed: AttributedString? { get set }
}
public extension OptionalAttributedText {
    var attributed: AttributedString? {
        get { attributedText.map { AttributedString($0) } }
        set { attributedText = newValue.map { NSAttributedString($0) } }
    }
}
public protocol ImplicitAttributedText: AnyObject {
    var attributedText: NSAttributedString! { get set }
    var attributed: AttributedString! { get set }
}
public extension ImplicitAttributedText {
    var attributed: AttributedString! {
        get { attributedText.map { AttributedString($0) } }
        set { attributedText = newValue.map { NSAttributedString($0) } }
    }
}

extension UILabel: OptionalAttributedText {}
extension UITextField: OptionalAttributedText {}
extension UITextView: ImplicitAttributedText {}
public extension UIButton {
    func attributed(for state: UIControl.State) -> AttributedString? {
        return attributedTitle(for: state).map { AttributedString($0) }
    }
    func setAttributed(_ title: AttributedString?, for state: UIControl.State) {
        setAttributedTitle(title.map { NSAttributedString($0) }, for: state)
    }
}

// MARK: UIColor

public extension UIColor {
    
    private var highlightedAlpha: CGFloat { 0.2 }
    
    var highlighted: UIColor {
        var alpha: CGFloat = 0.0
        if getRed(nil, green: nil, blue: nil, alpha: &alpha) {
            return withAlphaComponent(alpha * highlightedAlpha)
        }
        if getWhite(nil, alpha: &alpha) {
            return withAlphaComponent(alpha * highlightedAlpha) 
        }
        if getHue(nil, saturation: nil, brightness: nil, alpha: &alpha) {
            return withAlphaComponent(alpha * highlightedAlpha)
        }
        return withAlphaComponent(highlightedAlpha)
    }
}

public extension UIColor {
    
    static func | (light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    func resolvedColor(with userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        return resolvedColor(with: .init(userInterfaceStyle: userInterfaceStyle))
    }
}

public extension UIColor {
    
    convenience init(hex: UInt64) {
        self.init(hex: hex, alpha: 1.0)
    }
    convenience init(hex: UInt64, alpha: CGFloat) {
        let r = (hex & 0xFF0000) >> 16,
            g = (hex & 0x00FF00) >> 8,
            b = (hex & 0x0000FF)
        self.init(red:   CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue:  CGFloat(b) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
    convenience init(hex: String, alpha: CGFloat) {
        var hexString: String
        if hex.hasPrefix("#") {
            hexString = String(hex[1...]!)
        }
        else if hex.hasPrefix("0x") {
            hexString = String(hex[2...]!)
        }
        else {
            hexString = hex
        }
        guard hexString.count == 6 else {
            fatalError("invalid hex string: \(hex)")
        }
        var hexUInt: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexUInt)
        self.init(hex: hexUInt, alpha: alpha)
    }
}

// MARK: UIEdgeInsets

public extension UIEdgeInsets {
    init(top: Double, left: Double, bottom: Double, right: Double) {
        self.init(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
    }
    init(top: Int, left: Int, bottom: Int, right: Int) {
        self.init(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
    }
}

// MARK: Mutable

// constrain conforming types to subclasses of AnyObject
public protocol ObjectMutable: AnyObject {
    init()
}
extension NSObject: ObjectMutable, Mutable {}

public extension ObjectMutable where Self: AnyObject & ObjectMutable & Mutable {
    init(mutate: (Self) -> Void) {
        self.init()
        mutate(self)
    }
    init<T: AnyObject>(`var`: inout T?) {
        self.init()
        `var` = (self as! T)
    }
    init<T: AnyObject>(`var`: inout T?, mutate: (Self) -> Void) {
        self.init()
        mutate(self)
        `var` = (self as! T)
    }
    func mutate<T: AnyObject>(`var`: inout T?) -> Self {
        `var` = (self as! T)
        return self
    }
    func mutate<T: AnyObject>(`var`: inout T?, mutate: (Self) -> Void) -> Self {
        mutate(self)
        `var` = (self as! T)
        return self
    }
}

extension CGPoint: Mutable {}
extension CGSize: Mutable {}
extension CGRect: Mutable {}
extension UIEdgeInsets: Mutable {}

public extension UIResponder {
    func next<T>(of type: T.Type) -> T? {
        return (next as? T) ?? next?.next(of: type)
    }
    func closest<T>(of type: T.Type) -> T? {
        return (self as? T) ?? next?.closest(of: type)
    }
}

public extension UIView {
    func superview<T>(of type: T.Type) -> T? {
        return (superview as? T) ?? superview?.superview(of: type)
    }
}

public extension UIViewController {
    func parent<T>(of type: T.Type) -> T? {
        return (parent as? T) ?? parent?.parent(of: type)
    }
}

// UIViewController

public extension UIViewController {
    var currentContentViewController: UIViewController {
        if let tabBarController = self as? UITabBarController,
           let currentContentViewController = tabBarController.selectedViewController?.currentContentViewController {
            return currentContentViewController
        }
        if let splitViewController = self as? UISplitViewController,
           let currentContentViewController = (UIDevice.current.userInterfaceIdiom == .phone
                                               ? splitViewController.viewController(for: .primary)?.currentContentViewController
                                               : splitViewController.viewController(for: .secondary)?.currentContentViewController) {
            return currentContentViewController
        }
        if let navigationController = self as? UINavigationController,
           let currentContentViewController = navigationController.topViewController?.currentContentViewController {
            return currentContentViewController
        }
        // ???: presentedViewController
        return self
    }
}
