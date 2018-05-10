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
    
    func splitTweet(_ tweet: String?) throws -> [TweetComponent] {
        // Validate empty tweet
        
        guard let trimmedTweet = tweet?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedTweet.isEmpty else {
            throw TweetValidationError.empty
        }
        
        // If lengh of message is lesser than the maximum count -> Just return
        if trimmedTweet.count <= config.maxLength {
            var component = TweetComponent(indicator: TweetSlashIndicator(index: 0, total: 0))
            component.append(trimmedTweet, maxCount: config.maxLength)
            return [component]
        }
        
        // let targetSet = CharacterSet.whitespacesAndNewlines.union(CharacterSet.decimalDigits)
        // let isWordSeparator: (Character) -> Bool = { c in targetSet.contains(c.firstScalar) }
        
        let words = trimmedTweet.components(separatedBy: CharacterSet.whitespaces)
        
        // Validate if word's length exceed maxLength
        guard (words.filter { $0.count >= config.maxLength }).isEmpty else {
            throw TweetValidationError.wordLengthExceed
        }
        let total: UInt = trimmedTweet.count % config.maxLength == 0 ? UInt(trimmedTweet.count/config.maxLength) : UInt(trimmedTweet.count/config.maxLength) + 1
        
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
