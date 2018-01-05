//
//  GameScenceViewController.swift
//  DigitsGamble
//
//  Created by Mia on 03/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HexColors


class GameScenceViewController: UIViewController {
    
    @IBOutlet weak var digit1: DigitButton! { didSet  {digit1.tag = 1} }
    @IBOutlet weak var digit2: DigitButton! { didSet  {digit1.tag = 2} }
    @IBOutlet weak var digit3: DigitButton! { didSet  {digit1.tag = 3} }
    @IBOutlet weak var digit4: DigitButton! { didSet  {digit1.tag = 4} }
    @IBOutlet weak var digit5: DigitButton! { didSet  {digit1.tag = 5} }
    @IBOutlet weak var digit6: DigitButton! { didSet  {digit1.tag = 6} }
    @IBOutlet weak var digit7: DigitButton! { didSet  {digit1.tag = 7} }
    @IBOutlet weak var digit8: DigitButton! { didSet  {digit1.tag = 8} }
    @IBOutlet weak var digit9: DigitButton! { didSet  {digit1.tag = 9} }
    
    @IBOutlet weak var userInfoStack: UIStackView!
    
    @IBOutlet weak var userAInfo: UserInfoView!
    @IBOutlet weak var userBInfo: UserInfoView!
    
    @IBOutlet weak var offerTextField: UITextField!
    
    let disposeBag = DisposeBag()
    
    var digits: [DigitButton] = []
    
    var viewModel: GameModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        digits = [digit1, digit2, digit3, digit4, digit5, digit6, digit7, digit8, digit9]
        racBind()
        
        userAInfo.user = viewModel?.users[0]
        userBInfo.user = viewModel?.users[1]
        
        viewModel?.generateNextDigit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var confirm: UIButton!
    
    
    func racBind() {
        
        viewModel?.currentDigit
            .asObservable()
            .subscribe(onNext: { [unowned self] (digit) in
                if digit > 0 {
                    self.highlightButton(index: digit-1)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel?.currentUser
            .asObservable()
            .subscribe(onNext: { [unowned self] (user) in
                if user?.name == "A" {
                    self.userAInfo.isActivated = true
                    self.userBInfo.isActivated = false
                } else {
                    self.userAInfo.isActivated = false
                    self.userBInfo.isActivated = true
                }
            })
            .addDisposableTo(disposeBag)
        
        offerTextField
            .rx
            .text
            .asObservable()
            .map { (text) -> Bool in
                !(text?.isEmpty)!
            }
            .bind(to: confirm.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        
        confirm
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                self.viewModel?.currentUser.value?.offeredPrice.value = Int(self.offerTextField.text!)!
                self.viewModel?.currentUser.value?.offeredMark = true
                self.mayJudgeResults()
                self.resetPirceOfferTextField()
                self.changeToNextPlayer()
            })
            .addDisposableTo(disposeBag)
        
        viewModel?.winner.asObservable().subscribe(onNext: { (result) in
            if let winner = result {
                print("The Winner is \(winner)!!!")
                
            }
        })
        .addDisposableTo(disposeBag)
        
    }
    
    func mayJudgeResults() {
        if (viewModel?.shouldMakeAJudge())! {
            if let currentDigit = viewModel?.currentDigit.value {
                digits[currentDigit - 1].hasSold.value = true
                
            }
            
            viewModel?.judgeResults()
        }
    }
    
    func highlightButton(index: Int) {
        digits.forEach { (button) in
            button.shouldHighlight.value = false
        }
        digits[index].shouldHighlight.value = true
    }
    
    func resetPirceOfferTextField() {
        self.offerTextField.text = ""
    }
    
    func changeToNextPlayer() {
        viewModel?.nextPlayer()
    }
    
    static let Identifier = "GameScene"
    
}
