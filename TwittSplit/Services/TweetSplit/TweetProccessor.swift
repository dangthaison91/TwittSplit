//
//  TweetProccessor.swift
//  TwittSplit
//
//  Created by dangthaison on 5/8/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation

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
    let indicatorType: TweetIndicatorType.Type
    let maxLength: Int
    
    init(maxLength: Int = 50, indicatorType: TweetIndicatorType.Type = TweetSlashIndicator.self) {
        self.maxLength = maxLength
        self.indicatorType = indicatorType
    }
    
    func splitTweet(_ tweet: String?) throws -> SplitResult {
        // Validate empty tweet
        guard let trimmedTweet = tweet?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedTweet.isEmpty else {
            throw TweetValidationError.empty
        }
                
        // If length of tweet is less than the maximum count -> just return without index part
        if trimmedTweet.count <= maxLength {
            return SplitResult.message(trimmedTweet)
        }
        
        let words = trimmedTweet.components(separatedBy: CharacterSet.whitespaces)
        
        // Validate if word's length exceed maxLength
        guard (words.filter { $0.count >= maxLength }).isEmpty else {
            throw TweetValidationError.wordLengthExceed(maxLength)
        }
        let tweetLength = trimmedTweet.count
        let total: UInt = trimmedTweet.count % maxLength == 0 ? UInt(tweetLength/maxLength) : UInt(tweetLength/maxLength) + 1
        let tweetComponents = buildTweet(words: words, total: total)
        
        // Validate if indicator length is exceed tweet max length?
        let finalIndicator = indicatorType.init(index: UInt(tweetComponents.count), total: UInt(tweetComponents.count))
        
        if finalIndicator.toString().count >= maxLength {
            throw TweetValidationError.indicatorLengthExceed(maxLength)
        }
        
        return SplitResult.components(tweetComponents)
    }

    private func buildTweet(words: [String], total: UInt) -> [TweetComponent] {
        var index: UInt = 1
        var wordIndex = 0
        var component: TweetComponent = TweetComponent(indicator: indicatorType.init(index: index, total: total))
        var tweetComponents: [TweetComponent] = []
        
        // split tweet into tweet component
        while(wordIndex < words.count && index < words.count) {
            let word = words[wordIndex]
            let canAppend = component.append(word, maxLength: maxLength)
            
            if !canAppend {
                // Add component to array if it cannot append word any more
                tweetComponents.append(component)
                
                // Reset component
                index += 1
                component = TweetComponent(indicator: indicatorType.init(index: index, total: total))
                continue
            }
            
            wordIndex += 1
        }

        // Add last component
        tweetComponents.append(component)
        
        // build tweet again with `total` = number of tweet components
        // if number of parts is greater than total
        if tweetComponents.count > total {
            return buildTweet(words: words, total: UInt(tweetComponents.count))
        }
        return tweetComponents
    }
}
