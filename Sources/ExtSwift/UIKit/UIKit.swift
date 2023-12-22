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
            hexString = String(hex[1...])
        }
        else if hex.hasPrefix("0x") {
            hexString = String(hex[2...])
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
