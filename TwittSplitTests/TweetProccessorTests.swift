//
//  TweetProccessorTests.swift
//  TwittSplitTests
//
//  Created by dangthaison on 5/11/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import XCTest
@testable import TwittSplit

class TweetProccessorTests: XCTestCase {
    
    private let proccessor = TweetProccessor(maxLength: 50, indicatorType: TweetSlashIndicator.self)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyTweetMessage() {
        
        // Give
        let input = ""
        
        // When
        
        // Then
        XCTAssertThrowsError(try proccessor.splitTweet(input), "") { error in
            XCTAssertEqual(error as? TweetValidationError, TweetValidationError.empty)
        }
    }
    
    func testWordLongerThanMaximum() {
        
        // Give
        let input = "Hello, Swiftabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcab"
        
        // Then
        XCTAssertThrowsError(try proccessor.splitTweet(input), "") { error in
            XCTAssertEqual(error as? TweetValidationError, TweetValidationError.wordLengthExceed(proccessor.maxLength))
        }
    }
    
    func testIndicatorLongerThanMaximum() {
        
        // Give
        let input = "a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a"
        // When
        let proccessor = TweetProccessor(maxLength: 4, indicatorType: TweetSlashIndicator.self)
        
        // Then
        XCTAssertThrowsError(try proccessor.splitTweet(input), "") { error in
            XCTAssertEqual(error as? TweetValidationError, TweetValidationError.indicatorLengthExceed(proccessor.maxLength))
        }
    }
    
    func testTweetMessageShorterThanMaximum() {
        
        // Give
        let input = "Hi there"
        let expected = "Hi there"
        
        // When
        //        let processor = TweetSplitProcessor()
        guard let result = try? proccessor.splitTweet(input) else {
            XCTFail("Should not throw error for short message")
            return
        }
        
        // Then
        switch result {
        case .message(let tweet):
            XCTAssertEqual(tweet, expected, "Short message should be same the original")
            
        case .components:
            XCTFail("Should return original message")
            
        }
    }
    
    func testTheExampleInAssigment() {
        
        // Give
        let input = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        
        // When
        guard let result = try? proccessor.splitTweet(input) else {
            XCTFail("Should not throw error for valid message")
            return
        }
        
        // Then
        switch result {
        case .message:
            XCTFail("Should return multiple tweets")
            
        case .components(let tweets):
            XCTAssertEqual(tweets.filter { $0.tweet.count >= proccessor.maxLength }.count, 0, "There is no Tweet which length exceed the maximum")
            XCTAssertEqual(tweets.count, 2, "Should only 2 components")
            XCTAssertEqual(tweets.map { $0.tweet }, expected, "Same the expectation from the Assignment")
        }
    }
    
    func testLongTweetMessage() {
        
        // Give
        let input = "Every Observable sequence is just a sequence. The key advantage for an Observable vs Swift's Sequence is that it can also receive elements asynchronously. This is the kernel of the RxSwift, documentation from here is about ways that we expand on that idea."
        
        let expected = ["1/6 Every Observable sequence is just a sequence.",
                        "2/6 The key advantage for an Observable vs Swift's",
                        "3/6 Sequence is that it can also receive elements",
                        "4/6 asynchronously. This is the kernel of the",
                        "5/6 RxSwift, documentation from here is about ways",
                        "6/6 that we expand on that idea."]
        
        // When
        guard let result = try? proccessor.splitTweet(input) else {
            XCTFail("Should not throw error for valid message")
            return
        }
        
        // Then
        switch result {
        case .message:
            XCTFail("Should return multiple tweets")
            
        case .components(let tweets):
            XCTAssertEqual(tweets.filter { $0.tweet.count > proccessor.maxLength }.count, 0, "There is no Tweet which length exceed the maximum")
            XCTAssertEqual(tweets.map { $0.tweet }, expected, "Same the expectation")
        }
    }
    
    func testCustomTweetIndicator() {
        
        // Give
        let input = "The main goal of RxSwift project is to provide environment agnostic compositional computation glue abstracted in the form of observable sequences. We then aim to improve the experience of using RxSwift on specific platforms. To do this, RxCocoa uses generic computations to build more practical abstractions and wrap Foundation/Cocoa/UKit frameworks. That means that other libraries give context and semantics to the generic computation engine RxSwift provides such as Driver, ControlProperty, ControlEvents and more"
        
        let expected = ["(1/13) The main goal of RxSwift project is to",
                        "(2/13) provide environment agnostic compositional",
                        "(3/13) computation glue abstracted in the form of",
                        "(4/13) observable sequences. We then aim to",
                        "(5/13) improve the experience of using RxSwift on",
                        "(6/13) specific platforms. To do this, RxCocoa",
                        "(7/13) uses generic computations to build more",
                        "(8/13) practical abstractions and wrap",
                        "(9/13) Foundation/Cocoa/UKit frameworks. That",
                        "(10/13) means that other libraries give context",
                        "(11/13) and semantics to the generic computation",
                        "(12/13) engine RxSwift provides such as Driver,",
                        "(13/13) ControlProperty, ControlEvents and more"]
        
        // When
        let proccessor = TweetProccessor(maxLength: 50, indicatorType: BraceIndicator.self)
        guard let result = try? proccessor.splitTweet(input) else {
            XCTFail("Should not throw error for valid message")
            return
        }
        
        // Then
        switch result {
        case .message:
            XCTFail("Should return multiple tweets")
            
        case .components(let tweets):
            XCTAssertEqual(tweets.filter { $0.tweet.count > proccessor.maxLength }.count, 0, "There is no Tweet which length exceed the maximum")
            XCTAssertEqual(tweets.map { $0.tweet }, expected, "Same the expectation")
        }
    }
    
}
