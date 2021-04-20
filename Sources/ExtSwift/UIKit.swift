//
//  UIKit.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-04-20.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

// - seealso: https://developer.apple.com/documentation/swift/swift_standard_library/operator_declarations
infix operator |: AdditionPrecedence

public extension UIColor {
    static func | (light: UIColor, dark: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return light }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}
