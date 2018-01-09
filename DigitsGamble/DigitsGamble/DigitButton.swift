//
//  DigitButton.swift
//  DigitsGamble
//
//  Created by Mia on 05/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import UIKit
import HexColors
import RxCocoa
import RxSwift

class DigitButton: UIButton {
    
    let shouldHighlight = Variable(false)
    let hasSold = Variable(false)
    let hasPassed = Variable(false)
    let bag = DisposeBag()
    
    private let highlightColor = UIColor.orange
    private let availableColor = HexColor("7DA8EF")!
    private let soldColor = UIColor.lightGray
    private let passedColor = UIColor.yellow
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        racBind()
    }
    
    func reset() {
        shouldHighlight.value = false
        hasSold.value = false
        hasPassed.value = false
    }
    
    func racBind() {
        
        Observable.combineLatest(shouldHighlight.asObservable(), hasSold.asObservable(), hasPassed.asObservable()).subscribe(onNext: { (highlight, sold, passed) in
            self.backgroundColor = sold ? self.soldColor :
                passed ? self.passedColor :
                highlight ? self.highlightColor : self.availableColor
            
        })
        .addDisposableTo(bag)
        
    }
    
}
