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
import PCLBlurEffectAlert


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
    
    @IBOutlet weak var raise: UIButton!
    @IBOutlet weak var pass: UIButton!
    
    @IBOutlet weak var resetGame: UIButton!
    
    @IBOutlet weak var backToMain: UIButton!
    
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
    
    func racBind() {
        
        backToMain
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        
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
        
        raise
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                let alertController = PCLBlurEffectAlertController(title: "Raise",
                                                                   message: "How much do you want to raise?",
                                                                   style: .alert)
                let currentOffer: Variable<String?> = Variable("")
                alertController.addTextField(with: { (textField) in
                    textField?.placeholder = "Please offer a price"
                    textField?.keyboardType = .numberPad
                    textField?.rx.text.bind(to: currentOffer).addDisposableTo(self.disposeBag)
                })
                let okAction = PCLBlurEffectAlertAction(title: "OK", style: .default, handler: { [unowned self] (_) in
                    self.viewModel?.currentUser.value?.offeredPrice.value = Int(currentOffer.value!)!
                    self.viewModel?.currentUser.value?.availableFund.value -= Int(currentOffer.value!)!
                    self.changeToNextPlayer()
                })
                
                currentOffer.asObservable().subscribe(onNext: { (offer) in
                    if let price = Int(offer!) {
                        okAction.isEnabled = (self.viewModel?.currentUser.value?.availableFund.value)! >= price
                    }
                })
                .addDisposableTo(self.disposeBag)
             
                alertController.addAction(okAction)
                let cancelAction = PCLBlurEffectAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    
                })
                alertController.addAction(cancelAction)
                
                alertController.show()
            })
            .addDisposableTo(disposeBag)
        
        viewModel?.userCanRaise
            .asObservable()
            .bind(to: raise.rx.isEnabled)
            .addDisposableTo(disposeBag)
        
        pass
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                self.viewModel?.currentUser.value?.didPass = true
                self.changeToNextPlayer()
            })
            .addDisposableTo(disposeBag)
        
        
        viewModel?.winner
            .asObservable()
            .subscribe(onNext: { (result) in
                if let winner = result {
                    print("The Winner is \(winner)!!!")                    
                }
            })
            .addDisposableTo(disposeBag)

        resetGame
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [unowned self] (_) in
                self.viewModel?.resetGame()
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
    
    func changeToNextPlayer() {
        viewModel?.nextPlayer()
    }
    
    static let Identifier = "GameScene"
    
}
