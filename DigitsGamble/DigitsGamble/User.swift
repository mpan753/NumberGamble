//
//  User.swift
//  DigitsGamble
//
//  Created by Mia on 03/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class User: Equatable {

    var name: String

    var availableFund: Variable<Int>
    
    var ownedDigits: Variable<[Int]>

    init(name: String) {
        self.name = name
        self.availableFund = Variable(1000)
        self.ownedDigits = Variable([])
    }

    var offeredPrice: Variable<Int> = Variable(0)

    var didOffer: Bool = false
    
    var didPass: Bool = false
    
    func reset() {
        availableFund.value = 1000
        ownedDigits.value = []
        didOffer = false
        didPass = false
        offeredPrice.value = 0
    }
    
    func clearForNextRound() -> Void {
        didPass = false
        didOffer = false
        offeredPrice.value = 0
    }
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name
}
