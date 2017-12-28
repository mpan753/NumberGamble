//
//  StartViewController.swift
//  DigitsGamble
//
//  Created by Mia on 19/12/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        racBind()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var userA: UIButton!
    
    @IBOutlet weak var userB: UIButton!
    
    @IBOutlet weak var start: UIButton!
    
    let isUserA = Variable(false)
    
    
    let isUserB = Variable(false)
    
    let disposeBag = DisposeBag()
    
    
    func racBind() {
     
        // force unwrap to avoid having to deal with optionals later on
        let buttons = [userA, userB].map { $0! }
        
        // create an observable that will emit the last tapped button (which is
        // the one we want selected)

        let selectedButton = Observable.from(
            buttons.map { button in button.rx.tap.map { button } }
            ).merge()
        
        // for each button, create a subscription that will set its `isSelected`
        // state on or off if it is the one emmited by selectedButton

        buttons.reduce(Disposables.create()) { disposable, button in
            let subscription = selectedButton.map { $0 == button }
                .bind(to: button.rx.isSelected)
            
            // combine two disposable together so that we can simply call
            // .dispose() and the result of reduce if we want to stop all
            // subscriptions
            return Disposables.create(disposable, subscription)
            }
            .addDisposableTo(disposeBag)
        
        buttons.reduce(false) { enabled, button in
            return enabled || button.isSelected
        }
        .addDisposableTo(disposeBag)
    }
}
