//
//  ThemeTests.swift
//  ExtSwift
//
//  Created by Míng on 2023-12-14.
//  Copyright (c) 2023 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

final class ThemeTests: XCTestCase {
    
    func testThemeMakers() throws {
        UIView.autoUpdateThemeWhenMovedToSuperview()
        
        let view = UIView()
        view.makeTheme { this in
            let view = this as! UIView
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
        button.makeTheme { this in
            let button = this as! UIButton
            let color: UIColor = button.theme == "Dark" ? .white : .black
            button.setTitleColor(color, for: .normal)
        }
        XCTAssertEqual(button.titleColor(for: .normal), .black)
        
        view.addSubview(button)
        XCTAssertEqual(button.titleColor(for: .normal), .white)
    }
}
