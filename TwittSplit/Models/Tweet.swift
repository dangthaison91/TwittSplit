//
//  Tweet.swift
//  TwittSplit
//
//  Created by dangthaison on 5/10/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation
import RealmSwift

class Tweet: Object {
    
//    var id: Int = 0
    @objc dynamic var creator: User?
    @objc dynamic var content: String = ""
    @objc dynamic var createdAt: Date = Date() // Timestamp in seconds
    
//    override class func primaryKey() -> String? { return "createdAt" }
    
//    var createdDate: Date {
//        return Date(timeIntervalSince1970: TimeInterval(createdAt))
//    }
}
