//
//  WeakArray.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-03-02.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import Foundation

// Defined this protocol for `extension Array where Element: WeakBoxProtocol`
// - seealso: https://forums.swift.org/t/extension-on-array-where-element-is-generic-type/10225/6
public protocol WeakBoxProtocol {
    associatedtype Wrapped: AnyObject
    var wrapped: Wrapped? { get }
}

public class WeakBox<Wrapped: AnyObject>: WeakBoxProtocol {
    public private(set) weak var wrapped: Wrapped?
    public init(_ value: Wrapped) { wrapped = value }
}

public typealias WeakArray<Wrapped: AnyObject> = Array<WeakBox<Wrapped>>

public extension Array where Element: WeakBoxProtocol/* , Element.Wrapped: AnyObject */ {
    subscript(weak index: Index) -> Iterator.Element.Wrapped? {
        get {
            guard startIndex <= index && index < endIndex else { return nil }
            return self[index].wrapped
        }
        set {
            guard startIndex <= index && index <= endIndex else { return }
            if let newValue = newValue {
                self[index] = WeakBox(newValue) as! Element
            }
            else {
                remove(at: index)
            }
        }
    }
    mutating func compact() {
        removeAll { $0.wrapped == nil }
    }
}
