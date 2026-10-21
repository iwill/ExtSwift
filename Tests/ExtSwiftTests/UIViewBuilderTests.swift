//
//  UIViewBuilderTests.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-20.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

#if canImport(UIKit)
import UIKit

import ExtSwift

final class UIViewBuilderTests: XCTestCase {
    
    @MainActor
    func testUIViewBuilder() {
        _ = UIView { view in
            view.buildSubviews { 
                UIView()
                UIButton()
            }
        }
    }
}

#endif
