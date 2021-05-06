//
//  UIKit.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-04-20.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
public typealias UIResponder = NSResponder
public typealias UIView = NSView
#endif

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
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
#endif

// MARK: Mutable

#if os(iOS) || os(tvOS) || os(macOS)

public protocol ResponderMutable: UIResponder, Mutable {}
extension UIResponder: ResponderMutable {}

public extension ResponderMutable where Self: UIView {
    init(mutate: (Self) -> Void) {
        self.init()
        mutate(self)
    }
}

#endif
