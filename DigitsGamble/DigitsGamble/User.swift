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

    var availableFund: Int
    
    var ownedDigits: Variable<[Int]>

    init(name: String) {
        self.name = name
        self.availableFund = 1000
        self.ownedDigits = Variable([])
    }

    var offeredPrice: Variable<Int> = Variable(0)

    var offeredMark: Bool = false
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name
}
