//
//  TweetListViewController.swift
//  TwittSplit
//
//  Created by dangthaison on 5/10/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

public typealias TweetListSectionModel = AnimatableSectionModel<String, TweetCellModel>

public protocol TweetListViewModelInputs {}

public protocol TweetListViewModelOutputs {
    var tweets: Driver<[TweetListSectionModel]> { get }
}

public protocol TweetListViewModelType {
    var inputs: TweetListViewModelInputs { get }
    var outputs: TweetListViewModelOutputs { get }
}

class TweetListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: TweetListViewModelType! = TweetListViewModel()
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<TweetListSectionModel>!
    private let disposeBag = DisposeBag()
    
    private lazy var newTweetButton: UIBarButtonItem = UIBarButtonItem(image: Asset.tweetIcon.image, style: .plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = "Twitter"
        navigationItem.rightBarButtonItem = newTweetButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic

        viewModel
            .outputs.tweets
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        newTweetButton
            .rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.showNewTweetScreen()
            })
            .disposed(by: disposeBag)
    }
    
    func configureTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        dataSource = RxTableViewSectionedAnimatedDataSource<TweetListSectionModel>(configureCell: { (_, tableView, _, model) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetCell else {
                fatalError("Cannot dequeue cell with identfier: TweetCell")
            }
            cell.setModel(model)
            return cell
        })
    }
    
    private func showNewTweetScreen() {
        let newTweetViewController = StoryboardScene.Main.newTweetViewController.instantiate()
        newTweetViewController.viewModel = NewTweetViewModel()
        
        let naviController = UINavigationController(rootViewController: newTweetViewController)
        present(naviController, animated: true, completion: nil)
    }
}
