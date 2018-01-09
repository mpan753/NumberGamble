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

enum Offer  {
    case pass
    case price(Int)
    case none
    
    var description: String {
        switch self {
        case .pass:
            return "pass"
        case .price(let value):
            return "\(value)"
        case .none:
            return ""
        }
    }
    
    var price: Int {
        switch self {
        case .price(let value):
            return value
        default:
            return 0
        }
    }
}

class User: Equatable {

    var name: String

    var availableFund: Variable<Int>
    
    var ownedDigits: Variable<[Int]>

    init(name: String) {
        self.name = name
        self.availableFund = Variable(1000)
        self.ownedDigits = Variable([])
    }

    var offer: Variable<Offer> = Variable(.none)

    var didOffer: Bool = false
    
    func reset() {
        availableFund.value = 1000
        ownedDigits.value = []
        didOffer = false
        offer.value = .none
    }
    
    func clearForNextRound() -> Void {
        didOffer = false
        offer.value = .none
    }
    
    var digitsSum: Int {
        return ownedDigits.value.reduce(0, +)
    }
    
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name
}
