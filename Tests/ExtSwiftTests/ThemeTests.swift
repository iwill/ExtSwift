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
        UIView.es.autoUpdateThemeWhenMovedToSuperview()
        
        var view = UIView()
        view.es.makeTheme { view in
            let app = view // UIApplication.shared - <uninitialized>
            if app.es.theme == "Dark" {
                view.backgroundColor = .black
            }
            else {
                view.backgroundColor = .white
            }
        }
        XCTAssertEqual(view.backgroundColor, .white)
        view.es.theme = "Dark"
        XCTAssertEqual(view.es.theme, "Dark")
        XCTAssertEqual(view.backgroundColor, .black)
        
        let button = UIButton()
        button.es.makeTheme { button in
            let color: UIColor = button.es.theme == "Dark" ? .white : .black
            button.setTitleColor(color, for: .normal)
        }
        XCTAssertEqual(button.titleColor(for: .normal), .black)
        
        view.addSubview(button)
        XCTAssertEqual(button.titleColor(for: .normal), .white)
    }
}
