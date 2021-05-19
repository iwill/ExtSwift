//
//  SemanticVersion.swift
//  ExtSwift
//
//  Created by Mr. Ming on 2021-05-19.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#else
import Foundation
#endif

@testable
import ExtSwift

@available(*, deprecated, message: "Suppress warnings.")
final class SemanticVersionTests: XCTestCase {
    
    func testSemanticVersion() {
        
        // Features: 1.2, 1.2.0-alpha, 1.2.0-beta, 1.2.0, 1.2.0+build, 1.2.0.0, 1.2.99, 1.11.0
        
        XCTAssertTrue(2.semanticVersion         < "2.0-a")
        XCTAssertTrue("2.0-a".semanticVersion   < "2.0-b")
        XCTAssertTrue("2.0-b".semanticVersion   < 2.0)
        XCTAssertTrue(2.0.semanticVersion       < "2.0+a")
        XCTAssertTrue("2.0+a".semanticVersion   < "2.0+b")
        XCTAssertTrue("2.0+b".semanticVersion   < "2.0.0")
        XCTAssertTrue("2.0.0".semanticVersion   < 2.1)
        XCTAssertTrue(2.1.semanticVersion       < 2.99)
        XCTAssertTrue(2.99.semanticVersion      < 11.0)
        
        XCTAssertTrue("2.0-a".semanticVersion   < 2.0)
        XCTAssertTrue("2.0-a".semanticVersion   < "2.0+a")
        XCTAssertTrue("2.0-a".semanticVersion   < "2.0.0")
        XCTAssertTrue("2.0-a".semanticVersion   < "2.0.a")
        
        XCTAssertTrue(2.0.semanticVersion       < "2.0+a")
        XCTAssertTrue(2.0.semanticVersion       < "2.0.0")
        XCTAssertTrue(2.0.semanticVersion       < "2.0.a")
        
        XCTAssertTrue("2.0.0".semanticVersion   < "2.0.a")
        
        #if os(iOS) || os(tvOS)
        let systemVersion = UIDevice.current.systemVersion
        #elseif os(macOS)
        let osv = ProcessInfo.processInfo.operatingSystemVersion
        let systemVersion: String = [osv.majorVersion, osv.minorVersion, osv.patchVersion].map { String($0) }.joined(separator: ".")
        #else
        let systemVersion = "14.0"
        #endif
        XCTAssertTrue((systemVersion + "-beta").semanticVersion < systemVersion.semanticVersion)
        
        // test:
        
        let a = "1-a".replacingOccurrences(of: "-", with: "\0")
        let b = "1\0a"
        XCTAssertTrue(a == b)
        XCTAssertTrue(a.semanticVersion == b.semanticVersion)
        
        XCTAssertTrue(2 as SemanticVersion      == 2)
        XCTAssertTrue(2.0 as SemanticVersion    == 2.0)
        XCTAssertTrue("2.0.0" as SemanticVersion == "2.0.0")
        
        XCTAssertTrue(2.semanticVersion         <  2.0)
        XCTAssertTrue(2.semanticVersion         <  "2.0.0")
        XCTAssertTrue(2.0.semanticVersion       <  "2.0.0")
        
        XCTAssertTrue("2-a".semanticVersion     <  2)
        XCTAssertTrue(2.semanticVersion         <  2.0)
        XCTAssertTrue("2-a".semanticVersion     <  2.0)
        
        XCTAssertTrue("2-a".semanticVersion     <  2)
        XCTAssertTrue("2-a".semanticVersion     <= 2)
        XCTAssertTrue(2.semanticVersion         >  "2-a")
        XCTAssertTrue(2.semanticVersion         >= "2-a")
        
        XCTAssertTrue("2.0-a".semanticVersion   <  2.0)
        XCTAssertTrue(2.0.semanticVersion       <  "2.0.0")
        XCTAssertTrue("2.0-a".semanticVersion   <  "2.0.0")
        
        XCTAssertTrue("2.0.0-a".semanticVersion < "2.0.0-b")
        XCTAssertTrue("2.0.0-a".semanticVersion < "2.0.0")
        
        XCTAssertTrue("2.2.99".semanticVersion  <  2.11)
        
        let v1 = 2.0 as SemanticVersion // may be 2, 2.0 or "2.0.0"
        XCTAssertTrue(([2, 2.0, "2.0.0"] as [SemanticVersion]).contains(v1))
        
        let v2: SemanticVersion = 2, v3: SemanticVersion = 3
        XCTAssertTrue((..<v3).contains(1.2))
        XCTAssertTrue((v2..<v3).contains(2.1))
        XCTAssertTrue(!(...v3).contains(3.2))
        XCTAssertTrue(!(v2...v3).contains(4.3))
    }
    
    static var allTests = [
        ("testSemanticVersion", testSemanticVersion)
    ]
    
}
