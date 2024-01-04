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
    
    public typealias ConstraintClosure = (_ make: ConstraintMaker) -> Void
    public typealias ViewAndConstraintClosure = (UIView, ConstraintClosure?)
    
    public static func buildBlock(_ components: ViewAndConstraintClosure...) -> [ViewAndConstraintClosure] {
        return components
    }
    
    public static func buildBlock(_ components: [ViewAndConstraintClosure]...) -> [ViewAndConstraintClosure] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ components: [ViewAndConstraintClosure]?) -> [ViewAndConstraintClosure] {
        return components ?? []
    }
    
    public static func buildEither(first components: [ViewAndConstraintClosure]) -> [ViewAndConstraintClosure] {
        return components
    }
    
    public static func buildEither(second components: [ViewAndConstraintClosure]) -> [ViewAndConstraintClosure] {
        return components
    }
    
    public static func buildArray(_ components: [[ViewAndConstraintClosure]]) -> [ViewAndConstraintClosure] {
        return components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: ViewAndConstraintClosure) -> [ViewAndConstraintClosure] {
        return [expression]
    }
    
    public static func buildExpression(_ expression: [ViewAndConstraintClosure]) -> [ViewAndConstraintClosure] {
        return [expression].flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: UIView) -> [ViewAndConstraintClosure] {
        return [(expression, nil)]
    }
    
    public static func buildExpression(_ expression: [UIView]) -> [ViewAndConstraintClosure] {
        return expression.map { ($0, nil) }
    }
    
    public static func buildFinalResult(_ components: [ViewAndConstraintClosure]) -> [ViewAndConstraintClosure] {
        return components
    }
}

public extension ES where Base: UIView {
    
    @discardableResult
    func build(@UIViewBuilder _ buildSubviewsAndConstraints: () -> [UIViewBuilder.ViewAndConstraintClosure]) -> [some UIView] {
        let viewAndConstraintClosureArray = buildSubviewsAndConstraints()
        for (subview, _) in viewAndConstraintClosureArray {
            _base.addSubview(subview)
        }
        for (subview, closure) in viewAndConstraintClosureArray {
            if closure != nil {
                subview.snp.makeConstraints(closure!)
            }
        }
        return viewAndConstraintClosureArray.map { $0.0 }
    }
    
    func buildConstraints(_ closure: @escaping UIViewBuilder.ConstraintClosure) -> UIViewBuilder.ViewAndConstraintClosure {
        return (_base, closure)
    }
}

public extension ES where Base: UIControl {
    
    @discardableResult
    func buildHandler(for events: UIControl.Event, _ handler: @escaping (_ control: UIControl, _ event: UIControl.Event) -> Void) -> Base {
        addHandler(for: events, handler)
        return _base
    }
}

public extension ES where Base: UIButton {
    
    @discardableResult
    func buildHandler(_ handler: @escaping (_ button: Base) -> Void) -> Base {
        addHandler(handler)
        return _base
    }
}

public extension ES where Base: UITextField {
    
    @discardableResult
    func buildHandler(_ handler: @escaping (_ button: Base) -> Void) -> Base {
        addHandler(handler)
        return _base
    }
}
