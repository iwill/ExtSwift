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
/// - seealso: [solution](https://stackoverflow.com/a/42356615/456536)
/// - seealso: [issue](https://bugs.swift.org/browse/SR-10121)
/// - seealso: [pr](https://github.com/apple/swift/pull/23430)
public protocol MutableView: UIView, Mutable {}
public extension MutableView {
    init(mutate: (Self) -> Void) {
        self.init()
        mutate(self)
    }
}
extension UIView: MutableView {}
#endif
