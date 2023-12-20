//
//  UIViewBuilder.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-18.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
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
    
    public static func buildBlock(_ components: [UIViewAndConstraint]...) -> [UIViewAndConstraint] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ components: [UIViewAndConstraint]?) -> [UIViewAndConstraint] {
        return components ?? []
    }
    
    public static func buildEither(first components: [UIViewAndConstraint]) -> [UIViewAndConstraint] {
        return components
    }
    
    public static func buildEither(second components: [UIViewAndConstraint]) -> [UIViewAndConstraint] {
        return components
    }
    
    public static func buildArray(_ components: [[UIViewAndConstraint]]) -> [UIViewAndConstraint] {
        return components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: UIViewAndConstraint) -> [UIViewAndConstraint] {
        return [expression]
    }
    
    public static func buildExpression(_ expression: [UIViewAndConstraint]) -> [UIViewAndConstraint] {
        return [expression].flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: UIView) -> [UIViewAndConstraint] {
        return [(expression, nil)]
    }
    
    public static func buildExpression(_ expression: [UIView]) -> [UIViewAndConstraint] {
        return expression.map { ($0, nil) }
    }
    
    public static func buildFinalResult(_ components: [UIViewAndConstraint]) -> [UIViewAndConstraint] {
        return components
    }
}

public extension ES where Base: UIView {
    
    @discardableResult
    func build(@UIViewBuilder _ buildSubviewsAndConstraints: () -> [UIViewBuilder.UIViewAndConstraint]) -> [some UIView] {
        let viewAndConstraints = buildSubviewsAndConstraints()
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
