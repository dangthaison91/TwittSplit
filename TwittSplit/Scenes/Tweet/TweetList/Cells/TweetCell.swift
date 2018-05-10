//
//  TweetCell.swift
//  TwittSplit
//
//  Created by dangthaison on 5/10/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import UIKit
import Differentiator
import SwiftDate

public struct TweetCellModel {
    let id: Int
    let username: String
    let userId: String
    let createdDate: String
    let message: String
    
    init(tweet: Tweet) {
        self.id = Int(tweet.createdAt.timeIntervalSince1970)
        self.userId = tweet.creator?.userId ?? ""
        self.username = tweet.creator?.name ?? ""
        if tweet.createdAt.isInSameDayOf(date: Date()) {
            self.createdDate = tweet.createdAt.string(custom: "H:mm")
        } else {
            self.createdDate = tweet.createdAt.string(custom: "dd/MM/yyyy")
        }
        self.message = tweet.content
    }
}

extension TweetCellModel: IdentifiableType, Equatable {
    public typealias Identity = Int

    public var identity: Int {
        return id
    }
    
    public static func ==(lhs: TweetCellModel, rhs: TweetCellModel) -> Bool {
        return lhs.message == rhs.message
        && lhs.username == rhs.username
        && lhs.userId == rhs.userId
        && lhs.createdDate == rhs.createdDate
    }
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setModel(_ model: TweetCellModel) {
        userIdLabel.text = "@\(model.userId)"
        usernameLabel.text = model.username
        postDateLabel.text = model.createdDate
        tweetLabel.text = model.message
    }
}
