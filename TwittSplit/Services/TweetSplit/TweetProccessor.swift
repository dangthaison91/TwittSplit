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
    case empty, wordLengthExceed, indicatorLegnthExceed
}

enum SplitResult {
    case components([TweetComponent])
    case message(String)
    
}

struct TweetProccessor {
    let config: TweetConfig
    
    init(config: TweetConfig = TweetConfig()) {
        self.config = config
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
    
    func splitTweet2(_ tweet: String) throws -> [TweetComponent] {
        
        let trimmedTweet = tweet.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let maxLength = config.maxLength
        
        // Validate
        if trimmedTweet.isEmpty {
            throw TweetValidationError.empty
        }
//        if let error = validator.validateEmptyMessage(message) {
//            return .error(error)
//        }
//
//        // If lengh of message is lesser than the maximum count -> Just return
        if trimmedTweet.count <= config.maxLength {
            return [TweetComponent(indicator: TweetSlashIndicator(index: 0, total: 0))]
        }
        
        // Validate
//        if let error = validator.validateWordExcessMaximumCount(words, max: configuration.maxTweetCharacterCount) {
//            return .error(error)
//        }
//        let targetSet = CharacterSet.whitespacesAndNewlines.union(CharacterSet.decimalDigits)
//        let isWordSeparator: (Character) -> Bool = { c in targetSet.contains(c.firstScalar) }
        
        let words = tweet.components(separatedBy: CharacterSet.whitespaces)
        
        guard (words.filter { $0.count >= maxLength }).isEmpty else {
            throw TweetValidationError.wordLengthExceed
        }
        let total: UInt = trimmedTweet.count % maxLength == 0 ? UInt(trimmedTweet.count/maxLength) : UInt(trimmedTweet.count/maxLength) + 1
        // let total = getTotalParts(initial: initialParts, tweetLength: trimmedTweet.count)

        return buildTweet(words: words, total: total)
    }

    private func buildTweet(words: [String], total: UInt) -> [TweetComponent] {

        var index: UInt = 1
        var wordIndex = 0
        var component: TweetComponent = TweetComponent(indicator: TweetSlashIndicator(index: index, total: total))
        var tweetComponents: [TweetComponent] = []
        
        while(wordIndex < words.count) {
            let word = words[wordIndex]
            let canAppend = component.append(word, maxCount: config.maxLength)
            
            if !canAppend {
                tweetComponents.append(component)
                
                // Reset
                index += 1
                component = TweetComponent(indicator: TweetSlashIndicator(index: index, total: total))
                continue
            }
            
            wordIndex += 1
        }

        // Add last component
        tweetComponents.append(component)
        if tweetComponents.count > total {
            return buildTweet(words: words, total: UInt(tweetComponents.count))
        }
        return tweetComponents
    }
    
}
