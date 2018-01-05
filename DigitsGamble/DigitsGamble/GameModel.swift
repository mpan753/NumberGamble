//
//  GameModel.swift
//  DigitsGamble
//
//  Created by Mia on 03/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation
import GameKit
import RxCocoa
import RxSwift

class GameModel {
    
    var currentUser: Variable<User?> = Variable(nil)
    
    var users: [User]
    
    var leftOverNumbers: [Int]
    
    var shouldGenergateNext: Bool
    
    var currentDigit: Variable<Int> = Variable(0)
    
    let winner: Variable<String?> = Variable(nil)
    
    init(startViewModel model: StartViewModel) {
        self.users = model.users
        self.currentUser.value = self.users[model.selectedUserIndex!]
        self.leftOverNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Array(1...9)) as! [Int]
        self.shouldGenergateNext = true
    }
    
    func generateNextDigit() {
        _ = nextDigit()
    }
    
    private func nextDigit() -> Int {
        if !shouldGenergateNext {
            return currentDigit.value
        }
        if leftOverNumbers.count <= 0 {
            decideWinner()
            return 0
        }
        currentDigit.value = leftOverNumbers.popLast()!
        shouldGenergateNext = false
        return currentDigit.value
    }
    
    func nextPlayer() {
        if let index = users.index(where: {$0 == currentUser.value!}) {
            let nextIndex = (index + 1) % users.count
            currentUser.value = users[nextIndex]
        }
    }
    
    func judgeResults() {
        let userA = users[0]
        let userB = users[1]
        
        if userA.offeredPrice.value > userB.offeredPrice.value {
            userA.ownedDigits.value.append(currentDigit.value)
        } else {
            userB.ownedDigits.value.append(currentDigit.value)
        }
        print(userA.ownedDigits.value)
        print(userB.ownedDigits.value)
        shouldGenergateNext = true
        generateNextDigit()
        
        userA.offeredPrice.value = 0
        userB.offeredPrice.value = 0
        userA.offeredMark = false
        userB.offeredMark = false
    }
    
    func shouldMakeAJudge() -> Bool {
        return users.reduce(true, { (result, user) -> Bool in
            result && user.offeredMark
        })
    }
    
    func decideWinner() {
        let sumA = users[0].ownedDigits.value.reduce(0, +)
        let sumB = users[1].ownedDigits.value.reduce(0, +)
        let result = sumA > sumB ? "A" : "B"
        print(result)
        winner.value = result
    }
}
