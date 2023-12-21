//
//  UIKit.swift
//  ExtSwift
//
//  Created by Míng on 2021-04-20.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

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

extension CGPoint: Mutable {}
extension CGSize: Mutable {}
extension CGRect: Mutable {}

// constrain conforming types to subclasses of UIResponder
public protocol ResponderMutable: UIResponder {}
extension UIResponder: ResponderMutable, Mutable {}

public extension ResponderMutable where Self: UIView {
    init(mutate: (Self) -> Void) {
        self.init()
        mutate(self)
    }
}
