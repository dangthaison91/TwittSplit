//
//  TweetListViewModel.swift
//  TwittSplit
//
//  Created by dangthaison on 5/10/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension TweetListViewModel: TweetListViewModelType {
    var inputs: TweetListViewModelInputs { return self }
    var outputs: TweetListViewModelOutputs { return self }
}

class TweetListViewModel: TweetListViewModelInputs, TweetListViewModelOutputs {
    let tweets: Driver<[TweetListSectionModel]>

    init() {
        
        self.tweets = DataStore.observableObjects(type: Tweet.self)
            .map { tweets -> [TweetListSectionModel] in
                let cellModels = tweets
                    .sorted(byKeyPath: "createdAt", ascending: false)
                    .map { TweetCellModel(tweet: $0) }
                
                return [TweetListSectionModel(model: "", items: Array(cellModels))]
            }
            .asDriver(onErrorJustReturn: [])
    }
}
