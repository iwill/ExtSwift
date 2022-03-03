//
//  UIKitTests.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-04-27.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

#if os(iOS) || os(tvOS)
import UIKit
#endif

// @testable
import ExtSwift

final class UIKitTests: XCTestCase {
    
    func testMakable() {
        #if os(iOS) || os(tvOS)
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
        #endif
    }
    
    static var allTests = [
        ("testMakable", testMakable),
    ]
}
