//
//  ViewController.swift
//  TwittSplit
//
//  Created by dangthaison on 4/26/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let tweetProccessor = TweetProccessor()
                
        try! tweetProccessor.splitTweet2(string).forEach {
            debugPrint($0.tweet + ":" + "\($0.tweet.count)")
        }
//        let uber = "hi samuel johnse, your uber is arriving now!"
        let input = "One tap and a car comes directly to you. Hop in—your driver knows exactly where to go. And when you get there, just step out. Payment is completely seamless. Economy cars at everyday prices are always available. For special occasions, no occasion at all, or when you just a need a bit more room, call a black car or SUV."

        let uberConfig = TweetConfig(maxLength: 50)
        let uberProccessor = TweetProccessor(config: uberConfig)

        let ubers = try! uberProccessor.splitTweet2(input)
        
        ubers.forEach {
            debugPrint($0.tweet + ":" + "\($0.tweet.count)")
        }
    }
    
}

extension Character {
    var firstScalar: UnicodeScalar {
        return self.unicodeScalars.first ??  UnicodeScalar(0)
    }
}

extension String {
//    func split2(limit: Int, line: Int) -> [String] {
        // recursive
        
//    }
    
//    func splitWithIndex(limit: Int) -> [String] {
//        let trimString = self.trimmingCharacters(in: .whitespacesAndNewlines)
//        let initialLines = trimString.count % limit == 0 ? trimString.count/limit : Int(trimString.count/limit) + 1
//
////        if initialLines
//
//        var indexLength = Int(log10(Double(initialLines))) * 2 + 1
//
//        var splitStrings: [String] = []
//
//
////        var totalCharCount = 0
//
//        var finalLength = initialLines * indexLength + self.count
//
//        var finalLines = finalLength % limit == 0 ? finalLength/limit : Int(finalLength/limit) + 1
//        var finalIndexLength = Int(log10(Double(finalLines))) * 2 + 1
//
//        while finalLength != indexLength {
//            indexLength = Int(log10(Double(finalLines))) * 2 + 1
//
//            finalLength = initialLines * indexLength + self.count
//
//
//        }
//
//        let lineLimit = limit - indexLength
//
//        let targetSet = CharacterSet.whitespacesAndNewlines.union(CharacterSet.decimalDigits)
//        let isWordSeparator: (Character) -> Bool = { c in targetSet.contains(c.firstScalar) }
//        let words = self.split(whereSeparator: isWordSeparator).map { String($0) }
//
//        var tempString = ""
//        tempString.append(" ")
//        var currentPage = 1
//        var currentWordIndex = 0
//
//
//        while(currentWordIndex < words.count) {
//            let nextWordLength = words[currentWordIndex].count
//
//            if(tempString.count + nextWordLength + 1 < lineLimit) {
//                tempString.append(words[currentWordIndex])
//                tempString.append(" ")
//                currentWordIndex += 1
//            } else {
////                tempString = "\(currentPage)/\(lines)"
//                tempString = tempString.trimmingCharacters(in: .whitespacesAndNewlines)
//                splitStrings.append(tempString)
////                tempString = "\(currentPage + 1)/\(lines)"
//                tempString = ""
//                currentPage += 1
//            }
//        }
//        splitStrings.append(tempString)
//
//        let count = splitStrings.count
//
//        if
//        let finalStrings = splitStrings.enumerated().map { (index, string) -> String in
//            "\(index + 1)/\(count)" + " " + string
//        }
//
//        finalStrings.forEach { debugPrint($0.count) }
//        return finalStrings
//    }
}
