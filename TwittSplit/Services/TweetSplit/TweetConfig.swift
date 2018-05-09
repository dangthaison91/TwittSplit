//
//  TweetConfig.swift
//  TwittSplit
//
//  Created by dangthaison on 5/8/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation

struct TweetConfig {
    let maxLength: Int
    
    init(maxLength: Int = 50) {
        self.maxLength = maxLength
    }
}
