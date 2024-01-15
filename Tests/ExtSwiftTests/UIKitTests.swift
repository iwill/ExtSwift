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
    
    func testAttributedString() {
        let a = "text" | AttributeContainer()
            .font(UIFont.monospacedSystemFont(ofSize: 14.0, weight: .bold))
            .foregroundColor(.black)
        let b = AttributedString("text", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 14.0, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]))
        XCTAssertEqual(a, b)
    }
    
    func testMutable() {
        let frame = CGRectZero.mutating { rect in
            rect.size = CGSizeMake(1.0, 1.0)
        }
        XCTAssertEqual(frame, CGRectMake(0.0, 0.0, 1.0, 1.0))
        
        XCTAssertEqual(UIColor(hex: 0xffffff), .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        XCTAssertEqual(UIColor(hex: 0xFFFFFF), .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        XCTAssertEqual(UIColor(hex: 0xFfFfFf), .init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        XCTAssertEqual(UIColor(hex: 0x000000), .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        XCTAssertEqual(UIColor(hex: 0xFF0000), .red)
        XCTAssertEqual(UIColor(hex: 0x00FF00), .green)
        XCTAssertEqual(UIColor(hex: 0x0000FF), .blue)
        
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
