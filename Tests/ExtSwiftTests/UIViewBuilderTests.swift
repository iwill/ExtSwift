//
//  UIViewBuilderTests.swift
//  
//
//  Created by Míng on 2023-12-20.
//

import XCTest

#if canImport(UIKit)
import UIKit

import ExtSwift

final class UIViewBuilderTests: XCTestCase {
    
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
