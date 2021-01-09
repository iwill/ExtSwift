import XCTest
@testable import ExtSwift

final class ExtSwiftTests: XCTestCase {
    func testExtSwift() {
        XCTAssertEqual(ExtSwift().text, "Hello, ExtSwift!")
    }
    
    static var allTests = [
        ("testExtSwift", testExtSwift),
    ]
}
