//
//  TweetComponentTest.swift
//  TwittSplitTests
//
//  Created by dangthaison on 5/11/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import XCTest
@testable import TwittSplit

class TweetComponentTest: XCTestCase {
    
    fileprivate let maxLength = 50
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAppendNewWordStackWithoutExceed() {
        
        // Given
        let input = "Hello from the other side"

        // When
        let indicator = TweetSlashIndicator(index: 1, total: 2)
        var component = TweetComponent(indicator: indicator)
        _ = component.append(input, maxLength: maxLength)
        let canAppend = component.append("SWIFT", maxLength: maxLength)
        
        // Then
        XCTAssertTrue(canAppend, "Append short word should be OK")
    }
    
    func testCannotAppendNewWordCausedExceed() {
        
        // Given
        let input = "Hello from the other side"

        // When
        let indicator = TweetSlashIndicator(index: 1, total: 2)
        var component = TweetComponent(indicator: indicator)
        _ = component.append(input, maxLength: maxLength)
        let canAppend = component.append("SWIFTSWIFTSWIFTSWIFTSWIFTSWIFTSWIFTSWIFTSWIFT", maxLength: maxLength)
        
        // Then
        XCTAssertFalse(canAppend, "Should not enable to append long word")
    }
}
