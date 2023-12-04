//
//  SemanticVersion.swift
//  ExtSwift
//
//  Created by Mr. Míng on 2021-05-19.
//  Copyright (c) 2022 Mr. Míng <minglq.9@gmail.com>. Released under the MIT license.
//

import XCTest

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#else
import Foundation
#endif

// @testable
import ExtSwift

@available(*, deprecated, message: "Suppressing warnings.")
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
        
        let a = "1-a".replacingOccurrences(of: "-", with: "\0")
        let b = "1\0a"
        XCTAssertTrue(a == b)
        XCTAssertTrue(a.semanticVersion == b.semanticVersion)
        
        // See also the comparing results from https://semvercompare.azurewebsites.net/?version=1.2.3-zxcv&version=1.2.3&version=1.2.3%252Basdf&version=1.2.3%252Bqwer&version=1.2.3%252Basdf
        
        // 0. My test cases:
        
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
        
        XCTAssertTrue("2.0.0-a+a".semanticVersion > "2.0.0-a")
        XCTAssertTrue("2.0.0-a+a".semanticVersion < "2.0.0-b")
        XCTAssertTrue("2.0.0-a+a".semanticVersion < "2.0.0-b+a")
        XCTAssertTrue("2.0.0-a+a".semanticVersion < "2.0.0")
        XCTAssertTrue("2.0.0-a+a".semanticVersion < "2.0.0+a")
        
        XCTAssertTrue("2.2.99".semanticVersion  <  2.11)
        
        let v1 = 2.0 as SemanticVersion // may be 2, 2.0 or "2.0.0"
        XCTAssertTrue(([2, 2.0, "2.0.0"] as [SemanticVersion]).contains(v1))
        
        let v2: SemanticVersion = 2, v3: SemanticVersion = 3
        XCTAssertTrue((..<v3).contains(1.2))
        XCTAssertTrue((v2..<v3).contains(2.1))
        XCTAssertTrue(!(...v3).contains(3.2))
        XCTAssertTrue(!(v2...v3).contains(4.3))
        
        // 1. Test cases from https://semver.org/#spec-item-11
        
        // 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1
        XCTAssertTrue("1.0.0".semanticVersion < "2.0.0")
        XCTAssertTrue("2.0.0".semanticVersion < "2.1.0")
        XCTAssertTrue("2.1.0".semanticVersion < "2.1.1")
        
        // 1.0.0-alpha < 1.0.0
        XCTAssertTrue("1.0.0-alpha".semanticVersion < "1.0.0")
        
        // 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0
        XCTAssertTrue("1.0.0-alpha".semanticVersion < "1.0.0-alpha.1")
        XCTAssertTrue("1.0.0-alpha.1".semanticVersion < "1.0.0-alpha.beta")
        XCTAssertTrue("1.0.0-alpha.beta".semanticVersion < "1.0.0-beta")
        XCTAssertTrue("1.0.0-beta".semanticVersion < "1.0.0-beta.2")
        XCTAssertTrue("1.0.0-beta.2".semanticVersion < "1.0.0-beta.11")
        XCTAssertTrue("1.0.0-beta.11".semanticVersion < "1.0.0-rc.1")
        XCTAssertTrue("1.0.0-rc.1".semanticVersion < "1.0.0")
        
        // Build metadata MUST be ignored when determining version precedence.
        // XCTAssertTrue("1.0.0".semanticVersion == "1.0.0+asdf") // ❌ exp: =, got: <
        // XCTAssertTrue("1.0.0+qwer".semanticVersion == "1.0.0+asdf") // ❌ exp: =, got: >
        // Workaround by removing build metadata
        XCTAssertTrue("1.0.0".semanticVersion == "1.0.0+asdf".semanticVersion.removingBuildMetadata)
        XCTAssertTrue("1.0.0+qwer".semanticVersion.removingBuildMetadata == "1.0.0+asdf".semanticVersion.removingBuildMetadata)
        
        // 2. Test cases from [npm / node-semver](https://github.com/npm/node-semver/blob/main/test/fixtures/comparisons.js)
        
        XCTAssertTrue("0.0.1".semanticVersion > "0.0.0")
        XCTAssertTrue("1.0.0".semanticVersion > "0.9.9")
        XCTAssertTrue("0.10.0".semanticVersion > "0.9.0")
        XCTAssertTrue("0.99.0".semanticVersion > "0.10.0")
        XCTAssertTrue("2.0.0".semanticVersion > "1.2.3")
        XCTAssertTrue("1.2.3".semanticVersion > "1.2.3-asdf")
        XCTAssertTrue("1.2.3".semanticVersion > "1.2.3-4")
        XCTAssertTrue("1.2.3".semanticVersion > "1.2.3-4-foo")
        // Numeric identifiers always have lower precedence than non-numeric identifiers
        // XCTAssertTrue("1.2.3-5-foo".semanticVersion > "1.2.3-5") // ❌ exp: >, got: <
        XCTAssertTrue("1.2.3-5".semanticVersion > "1.2.3-4")
        XCTAssertTrue("1.2.3-5-foo".semanticVersion > "1.2.3-5-Foo")
        XCTAssertTrue("3.0.0".semanticVersion > "2.7.2+asdf")
        XCTAssertTrue("1.2.3-a.10".semanticVersion > "1.2.3-a.5")
        XCTAssertTrue("1.2.3-a.b".semanticVersion > "1.2.3-a.5")
        XCTAssertTrue("1.2.3-a.b".semanticVersion > "1.2.3-a")
        XCTAssertTrue("1.2.3-a.b.c.10.d.5".semanticVersion > "1.2.3-a.b.c.5.d.100")
        // Identifiers with letters or hyphens are compared lexically in ASCII sort order
        // XCTAssertTrue("1.2.3-r2".semanticVersion > "1.2.3-r100") // ❌ exp: >, got: <
        XCTAssertTrue("1.2.3-r100".semanticVersion > "1.2.3-R2")
    }
    
    static var allTests = [
        ("testSemanticVersion", testSemanticVersion)
    ]
}
