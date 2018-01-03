//
//  GameModel.swift
//  DigitsGamble
//
//  Created by Mia on 03/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation
import GameKit

class GameModel {
    
    var currentUser: User
    
    var leftOverNumbers: [Int] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Array(1...9)) as! [Int]
    
    init(initialUser user: User) {
        self.currentUser = user
    }
    
    func nextDigit() -> Int {
        return leftOverNumbers.popLast()!
    }
}
