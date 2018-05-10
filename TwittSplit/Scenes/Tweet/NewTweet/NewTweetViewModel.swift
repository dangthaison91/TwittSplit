//
//  NewTweetViewModel.swift
//  TwittSplit
//
//  Created by dangthaison on 5/10/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

extension NewTweetViewModel: NewTweetViewModelType {
    var inputs: NewTweetViewModelInputs { return self }
    var outputs: NewTweetViewModelOutputs { return self }
}

class NewTweetViewModel: NewTweetViewModelInputs, NewTweetViewModelOutputs {
    
    // Inputs
    var tweet = BehaviorRelay<String?>(value: nil)
    let sendTweet = PublishRelay<Void>()
    
    // Outputs
    private(set) lazy var twitSuccessful: Driver<Bool> = self.successfulRelay.asDriver(onErrorJustReturn: false)
    
    private let successfulRelay = PublishRelay<Bool>()
    private let errorRelay = PublishRelay<Error>()

    private let tweetProccessor = TweetProccessor()
    private let disposeBag = DisposeBag()
    
    init() {
        let sendTweetResult = sendTweet
            .withLatestFrom(tweet)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .flatMap { [unowned self] message in
                return self.splitMessage(message).materialize()
        }
        
        sendTweetResult
            .elements()
            .subscribe(onNext: { [unowned self] tweets in
                self.saveTweets(tweets)
                self.successfulRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        sendTweetResult
            .errors()
            .bind(to: errorRelay)
            .disposed(by: disposeBag)
    }
    
    func splitMessage(_ message: String?) -> Observable<[TweetComponent]> {
        let tweetProccessor = self.tweetProccessor
        
        return Observable.create { (observer) -> Disposable in
            do {
                let tweets = try tweetProccessor.splitTweet(message)
                observer.onNext(tweets)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func saveTweets(_ components: [TweetComponent]) {
        
        let tweets = components.reversed().map { component -> Tweet in
            let tweet = Tweet()
            tweet.content = component.tweet
            tweet.creator = User()
            return tweet
        }
        
        try! DataStore.realm.write {
            DataStore.realm.add(tweets, update: false)
        }
    }
}
