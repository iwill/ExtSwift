//
//  SnapKit+superview.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-19.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit
import SnapKit

public extension ConstraintViewDSL {
    
    @discardableResult
    func prepareConstraints(in superview: ConstraintView? = nil, _ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        if let view = self.target as? ConstraintView,
           superview?.contains(view) == false {
            superview?.addSubview(view)
        }
        return prepareConstraints(closure)
    }
    
    func makeConstraints(in superview: ConstraintView? = nil, _ closure: (_ make: ConstraintMaker) -> Void) {
        if let view = self.target as? ConstraintView,
           superview?.contains(view) == false {
            superview?.addSubview(view)
        }
        makeConstraints(closure)
    }
    
    func remakeConstraints(in superview: ConstraintView? = nil, _ closure: (_ make: ConstraintMaker) -> Void) {
        if let view = self.target as? ConstraintView,
           superview?.contains(view) == false {
            superview?.addSubview(view)
        }
        remakeConstraints(closure)
    }
    
    func updateConstraints(in superview: ConstraintView? = nil, _ closure: (_ make: ConstraintMaker) -> Void) {
        if let view = self.target as? ConstraintView,
           superview?.contains(view) == false {
            superview?.addSubview(view)
        }
        updateConstraints(closure)
    }
}
