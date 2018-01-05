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
    
    var shouldHighlight = Variable(false)
    var hasSold = Variable(false)
    let bag = DisposeBag()
    
    private let highlightColor = UIColor.orange
    private let availableColor = HexColor("7DA8EF")!
    private let soldColor = UIColor.lightGray
    
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
    
    func racBind() {
        
        Observable.combineLatest(shouldHighlight.asObservable(), hasSold.asObservable()).subscribe(onNext: { (highlight, sold) in
            self.backgroundColor = sold ? self.soldColor : highlight ? self.highlightColor : self.availableColor
            
        })
        .addDisposableTo(bag)
        
    }
    
}
