//
//  BraceIndicator.swift
//  TwittSplitTests
//
//  Created by dangthaison on 5/11/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation
@testable import TwittSplit

struct BraceIndicator: TweetIndicatorType {
    let index: UInt
    let total: UInt
    
    init(index: UInt, total: UInt) {
        self.index = index
        self.total = total
    }
    
    func toString() -> String {
        return "(\(index)/\(total))"
    }
    
}
