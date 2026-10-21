//
//  ThemeTests.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-14.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

#if canImport(UIKit)
import UIKit

final class ThemeTests: XCTestCase {
    
    @available(iOS, introduced: 13.0, deprecated: 17.0, message: "Use `UITraitDefinition` insead: https://developer.apple.com/videos/play/wwdc2023/10057/")
    @MainActor
    func testThemeMakers() throws {
        UIView.autoUpdateThemeWhenMovedToSuperview()
        
        let view = UIView()
        view.makeTheme { view in
            let app = view // UIApplication.shared - <uninitialized>
            if app.theme == "Dark" {
                view.backgroundColor = .black
            }
            else {
                view.backgroundColor = .white
            }
        }
        XCTAssertEqual(view.backgroundColor, .white)
        view.theme = "Dark"
        XCTAssertEqual(view.theme, "Dark")
        XCTAssertEqual(view.backgroundColor, .black)
        
        let button = UIButton()
        button.makeTheme { button in
            let color: UIColor = button.theme == "Dark" ? .white : .black
            button.setTitleColor(color, for: .normal)
        }
        XCTAssertEqual(button.titleColor(for: .normal), .black)
        
        view.addSubview(button)
        XCTAssertEqual(button.titleColor(for: .normal), .white)
    }
}

#endif
