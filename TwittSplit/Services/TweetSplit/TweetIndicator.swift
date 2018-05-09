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
    func toString() -> String
}

struct TweetSlashIndicator: TweetIndicatorType {
    let index: UInt
    let total: UInt
    
    func toString() -> String {
        return "\(index)/\(total)"
    }
}
