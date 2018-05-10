//
//  TweetIndicator.swift
//  TwittSplit
//
//  Created by dangthaison on 5/9/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation

protocol TweetIndicatorType {
    var index: UInt { get }
    var total: UInt { get }
    
    init(index: UInt, total: UInt)
    func toString() -> String
}

struct TweetSlashIndicator: TweetIndicatorType {
    let index: UInt
    let total: UInt
    
    init(index: UInt, total: UInt) {
        self.index = index
        self.total = total
    }

    func toString() -> String {
        return "\(index)/\(total)"
    }
}
