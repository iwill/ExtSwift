//
//  UIKitTests.swift
//  ExtSwift
//
//  Created by Míng on 2021-04-27.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

import UIKit

// @testable
import ExtSwift

final class UIKitTests: XCTestCase {
    
    func testMakable() {
        let view = UIView { view in
            view.backgroundColor = .white
        }
        .mutate { view in
            view.backgroundColor = .black
        }
        let label = UILabel { label in
            label.text = "init"
        }
        .mutate { label in
            label.text = "mutate"
        }
        view.addSubview(label)
        XCTAssertEqual(label.superview, view)
    }
}
