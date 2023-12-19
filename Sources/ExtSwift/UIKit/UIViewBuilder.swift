//
//  UIViewBuilder.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-18.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit
import SnapKit

/// SwiftUIKit != SwiftUI + Kit
/// SwiftUIKit == Swift + UIKit // UIKit + Swift resultBuilder

@resultBuilder
public struct UIViewBuilder: Hashable {
    
    public typealias UIViewAndConstraint = (UIView, [Constraint]?)
    
    public static func buildBlock(_ components: UIViewAndConstraint...) -> [UIViewAndConstraint] {
        return components
    }
}

public extension ES where Base: UIView {
    
    @discardableResult
    func build(@UIViewBuilder _ makeSubviews: () -> [UIViewBuilder.UIViewAndConstraint]) -> [UIView] {
        let viewAndConstraints = makeSubviews()
        for (subview, constraints) in viewAndConstraints {
            _base.addSubview(subview)
            for constraint in constraints ?? [] {
                constraint.activate()
            }
        }
        return viewAndConstraints.map { $0.0 }
    }
    
    func buildConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> UIViewBuilder.UIViewAndConstraint {
        return (_base, _base.snp.prepareConstraints(closure))
    }
}
