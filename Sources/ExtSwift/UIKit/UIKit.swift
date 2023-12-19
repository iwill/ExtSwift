//
//  UIKit.swift
//  ExtSwift
//
//  Created by Míng on 2021-04-20.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
public typealias UIResponder = NSResponder
public typealias UIView = NSView
public typealias UIEdgeInsets = NSEdgeInsets
#endif

// MARK: ESNameSpace

extension UIResponder: ESNameSpace {}

/// - seealso: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
infix operator |: AdditionPrecedence

// MARK: NSAttributedString

public extension String {
    static func | (string: String, attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes)
    }
}

// MARK: UIColor

#if os(iOS) || os(tvOS)
public extension UIColor {
    static func | (light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, tvOS 13.0, *) else { return light }
        return UIColor { traitCollection -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
    func resolvedColor(with userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        guard #available(iOS 13.0, tvOS 13.0, *) else { return self }
        return resolvedColor(with: .init(userInterfaceStyle: userInterfaceStyle))
    }
}
#endif

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


public protocol ResponderMutable: UIResponder {}
extension UIResponder: ResponderMutable, Mutable {}

public extension ResponderMutable where Self: UIView {
    init(mutate: (Self) -> Void) {
        self.init()
        mutate(self)
    }
}
