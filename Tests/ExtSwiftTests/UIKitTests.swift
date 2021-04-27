//
//  UIKitTests.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-04-27.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@testable
import ExtSwift

final class UIKitTests: XCTestCase {
    
    func testMakable() {
        #if canImport(UIKit) || canImport(AppKit)
        let view = UIView { (view) in
            view.backgroundColor = .white
        }
        let label = UILabel().make { (label) in
            label.text = "test"
        }
        view.addSubview(label)
        XCTAssertEqual(label.superview, view)
        #endif
    }
    
    static var allTests = [
        ("testMakable", testMakable),
    ]
    
}
