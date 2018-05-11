# TwittSplit

## Requirements
- iOS >= 10.0
- Xcode 9
- Swift 4.1

## Install 
```
$ pod install
```

## What I've done
+ Twitter App with TwitSplit algorithm.
+ Unit tests for TwitSplit algorithm.
+ MVVM+Rx architecture with Uni-directional Data Flow in mind. Followed this guideline: https://www.slideshare.net/ThaiSonDang3/mvvm-rxswift
+ Used Realm Database for Single Source of Truths

## TODO
+ Unit test for Twitter App
+ Use FlowController/Coordinator to make ViewController respect Separation of Concern principle.

## How TwitSplit works?

+ **TweetComponent:** represent chunked message parts. For example *"1/2 I can't believe Tweeter now supports chunking"* is a TweetComponent
+ **TweetProcessor:** All main algorithm will run here, help to separates message in to multiple parts ([TweetComponent]).
+ **TweetIndicator:** indicator format for TweetComponent.

## Algorithm

  - **Step 1:** Remove whitespaces characters from input message.
  - **Step 2:** Return error if message is empty.
  - **Step 3:** Return original input message if it is shorter than max length.
  - **Step 4:** Seperate input message into individual words, return error if word's length greater than limit.
  - **Step 5:** Estimate number of part.
  - **Step 6:** [Build Tweets]() with `estimatedTotal` 
  - **Step 7:** If `results.count` is greater than `estimatedTotal` => `estimatedTotal` = `results.count`. Back to **Step 6**.
  - **Step 8:** Return error if final indicator's length is greater than limit else return results as array of tweet parts. 