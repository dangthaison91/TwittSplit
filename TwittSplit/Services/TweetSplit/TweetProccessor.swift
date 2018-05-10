//
//  TweetProccessor.swift
//  TwittSplit
//
//  Created by dangthaison on 5/8/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation

extension Int {
    var numberDigits: Int {
        if self < 10 {
            return 1
        } else {
            return 1 + (self/10).numberDigits
        }
    }
}

enum TweetValidationError: Error {
    case empty
    case wordLengthExceed(Int)
    case indicatorLengthExceed(Int)
}

extension TweetValidationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return "Please enter your message"
            
        case .indicatorLengthExceed:
            return "Your message is too long. Please cut it down!"
            
        case .wordLengthExceed(let length):
            return "Your words must be shorter than \(length) characters"
        }
    }
}

enum SplitResult {
    case components([TweetComponent])
    case message(String)
}

struct TweetProccessor {
    let config: TweetConfig
    let indicator: TweetIndicatorType
    
    init(config: TweetConfig = TweetConfig(), indicator: TweetIndicatorType) {
        self.config = config
        self.indicator = indicator
    }

//    func getTotalParts(initial: Int, tweetLength: Int) -> Int {
//
//        let indicatorLength = initial.numberDigits * 2 + 2
//
//        let newTweetLength = initial * indicatorLength + tweetLength
//        let newParts = newTweetLength % config.maxLength == 0 ? newTweetLength/config.maxLength : Int(newTweetLength/config.maxLength) + 1
//
//        let newIndicatorLength = newParts.numberDigits * 2 + 2
//
//        if indicatorLength == newIndicatorLength {
//            return newParts
//        } else {
//            return getTotalParts(initial: newParts, tweetLength: tweetLength)
//        }
//    }
    
    func splitTweet(_ tweet: String?) throws -> SplitResult {
        // Validate empty tweet
        guard let trimmedTweet = tweet?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedTweet.isEmpty else {
            throw TweetValidationError.empty
        }
        
        let maxLength = config.maxLength
        
        // If length of tweet is less than the maximum count -> just return without index part
        if trimmedTweet.count <= maxLength {
            return SplitResult.message(trimmedTweet)
        }
        
        let words = trimmedTweet.components(separatedBy: CharacterSet.whitespaces)
        
        // Validate if word's length exceed maxLength
        guard (words.filter { $0.count >= maxLength }).isEmpty else {
            throw TweetValidationError.wordLengthExceed(maxLength)
        }
        let total: UInt = trimmedTweet.count % maxLength == 0 ? UInt(trimmedTweet.count/maxLength) : UInt(trimmedTweet.count/maxLength) + 1
        let tweetComponents = buildTweet(words: words, total: total)
        
        // Validate if indicator length is exceed tweet max length?
        let finalIndicator = type(of: indicator).init(index: UInt(tweetComponents.count), total: UInt(tweetComponents.count))
        
        if finalIndicator.toString().count >= maxLength {
            throw TweetValidationError.indicatorLengthExceed(maxLength)
        }
        
        return SplitResult.components(tweetComponents)
    }

    private func buildTweet(words: [String], total: UInt) -> [TweetComponent] {

        var index: UInt = 1
        var wordIndex = 0
        var component: TweetComponent = TweetComponent(indicator: type(of: indicator).init(index: index, total: total))
        var tweetComponents: [TweetComponent] = []
        
        // split tweet into tweet component
        while(wordIndex < words.count) {
            let word = words[wordIndex]
            let canAppend = component.append(word, maxCount: config.maxLength)
            
            if !canAppend {
                // Add component to array if it cannot append word any more
                tweetComponents.append(component)
                
                // Reset
                index += 1
                component = TweetComponent(indicator: type(of: indicator).init(index: index, total: total))
                continue
            }
            
            wordIndex += 1
        }

        // Add last component
        tweetComponents.append(component)
        
        // build tweet again with total = number of tweet components
        // if number of parts is greater than total
        if tweetComponents.count > total {
            return buildTweet(words: words, total: UInt(tweetComponents.count))
        }
        return tweetComponents
    }
}
