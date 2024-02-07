//
//  String+IntIndexTests.swift
//  ExtSwift
//
//  Created by Míng on 2021-03-19.
//  Copyright (c) 2022 Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest
import UIKit

// @testable
import ExtSwift

final class IntIndexTests: XCTestCase {
    
    func testIntIndex() {
        
        let fingers = "👌🏿👍🏿🤞🏿🤟🏿"
        
        // Int to String.Index
        let index = fingers.index(from: 3)
        XCTAssertEqual(index, fingers.index(before: fingers.endIndex))
        // String.Index to Int
        let intIndex = fingers.intIndex(from: fingers.endIndex)
        XCTAssertEqual(intIndex, 4)
        
        // String at Index
        let three = fingers[3]
        XCTAssertEqual(three, "🤟🏿")
        
        // Range<Int>
        let eq1_lt3 = fingers[1..<3]
        XCTAssertEqual(eq1_lt3, "👍🏿🤞🏿")
        let eq1lt4 = fingers[1..<4]
        XCTAssertEqual(eq1lt4, "👍🏿🤞🏿🤟🏿")
        
        // ClosedRange<Int>
        let eq1_eq2 = fingers[1...2]
        XCTAssertEqual(eq1_eq2, "👍🏿🤞🏿")
        let eq1_eq3 = fingers[1...3]
        XCTAssertEqual(eq1_eq3, "👍🏿🤞🏿🤟🏿")
        
        // PartialRangeUpTo<Int>
        let _lt1 = fingers[..<1]
        XCTAssertEqual(_lt1, "👌🏿")
        // PartialRangeThrough<Int>
        let _eq1 = fingers[...1]
        XCTAssertEqual(_eq1, "👌🏿👍🏿")
        // PartialRangeFrom<Int>
        let eq2_ = fingers[2...]
        XCTAssertEqual(eq2_, "🤞🏿🤟🏿")
        
        let textView = UITextView()
        textView.resignFirstResponder()
        textView.endEditing(true)
        print("textView.selectedRange: \(textView.selectedRange)")
        
        textView.text = "🤟🏿"
        XCTAssertEqual(textView.text.count, 1)
        
        textView.selectAll(nil)
        let selectedRange = textView.selectedRange
        print("selectedRange: \(selectedRange)")
        XCTAssertEqual(selectedRange.location, 0)
        XCTAssertEqual(selectedRange.length, 4)
        XCTAssertEqual(selectedRange.length, textView.text.utf16.count)
        
        if let range = Range(textView.selectedRange, in: textView.text) {
            let intRange = textView.text.intRange(from: range)
            print("intRange: \(intRange)")
            let text = textView.text[intRange]
            // let text = textView.text[range]
            XCTAssertEqual(text, "🤟🏿")
        }
        else {
            XCTFail()
        }
        
        let intRange = textView.selectedIntRange
        XCTAssertEqual(intRange.lowerBound, 0)
        XCTAssertEqual(intRange.upperBound, 1)
        
        let s: String = ""
        let r: Range<String.Index> = s.startIndex..<s.startIndex
        let sub = s[r]
        print("sub: [\(sub)]")
        
        let intR: Range<Int> = 0..<0 // 0..<1 -> crash
        let intSub = s[intR]
        print("intSub: [\(intSub)]")
        
        // runtime error
        // XCTAssertThrowsError(fingers[5])
        // XCTAssertThrowsError(fingers[1..<5])
        // XCTAssertThrowsError(fingers[1...5])
    }
}
