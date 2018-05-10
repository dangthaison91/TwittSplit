//
//  TweetComponent.swift
//  TwittSplit
//
//  Created by dangthaison on 5/8/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation

struct TweetComponent {
    let indicator: TweetIndicatorType
    private(set) var tweet: String = ""
    
    init(indicator: TweetIndicatorType) {
        self.indicator = indicator
        if indicator.total > 0 {
            self.tweet = indicator.toString()
        }
    }
    
    mutating func append(_ newWord: String, maxCount: Int) -> Bool {
        
        // Estimate the length of tweet
        let nextCount = tweet.count + newWord.count + 1
        
        // If the length of tweet is excessed the limit
        // Return false and don't add to stack
        guard nextCount <= maxCount else {
            return false
        }
        
        // Append next word into tweet
        tweet = tweet + " " + newWord
        
        return true
    }
}
