//
//  NewTweetViewController.swift
//  TwittSplit
//
//  Created by dangthaison on 5/10/18.
//  Copyright © 2018 sondt. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public protocol NewTweetViewModelInputs {
    var tweet: BehaviorRelay<String?> { get }
    var sendTweet: PublishRelay<Void> { get }
}

public protocol NewTweetViewModelOutputs {
    var twitSuccessful: Driver<Bool> { get }
}

public protocol NewTweetViewModelType {
    var inputs: NewTweetViewModelInputs { get }
    var outputs: NewTweetViewModelOutputs { get }
}

class NewTweetViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    private lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    private lazy var sendTweetButton: UIBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: nil, action: nil)

    var viewModel: NewTweetViewModelType! = NewTweetViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendTweetButton
        
        cancelButton
            .rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        sendTweetButton
            .rx.tap
            .bind(to: viewModel.inputs.sendTweet)
            .disposed(by: disposeBag)
        
        viewModel
            .outputs.twitSuccessful
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        textView
            .rx.text
            .bind(to: viewModel.inputs.tweet)
            .disposed(by: disposeBag)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
}
