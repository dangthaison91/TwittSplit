//
//  TweetValidationError+Equatable.swift
//  TwittSplitTests
//
//  Created by dangthaison on 5/11/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation
@testable import TwittSplit

extension TweetValidationError: Equatable {
    public static func ==(lhs: TweetValidationError, rhs: TweetValidationError) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
            
        case (.wordLengthExceed(let lhsValue), .wordLengthExceed(let rhsValue)):
            return lhsValue == rhsValue
            
        case (.indicatorLengthExceed(let lhsValue), .indicatorLengthExceed(let rhsValue)):
            return lhsValue == rhsValue
            
        default:
            return false
        }
    }
}
