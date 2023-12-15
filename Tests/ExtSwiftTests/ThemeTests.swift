//
//  ThemeTests.swift
//  
//
//  Created by Míng on 2023-12-14.
//

import XCTest

final class ThemeTests: XCTestCase {
    
    func testThemeMakers() throws {
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
    }
}
