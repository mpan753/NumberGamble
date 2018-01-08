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
    
    let userCanRaise: Variable<Bool> = Variable(true)
    
    var firstMoveUserIndex: Int
    
    init(startViewModel model: StartViewModel) {
        self.users = model.users
        self.firstMoveUserIndex = model.selectedUserIndex!
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
            checkIfUserCanRaise()
        }
    }
    
    private func checkIfUserCanRaise() {
        userCanRaise.value = (currentUser.value?.availableFund.value)! > 0
        print(userCanRaise.value)
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
        
        users.forEach { (user) in
            user.clearForNextRound()
        }
    }
    
    func shouldMakeAJudge() -> Bool {
        
        let allPass = users.reduce(true) { (result, user) -> Bool in
            result && user.didPass
        }
        if allPass { return true }
    }
    
    func decideWinner() {
        let sumA = users[0].ownedDigits.value.reduce(0, +)
        let sumB = users[1].ownedDigits.value.reduce(0, +)
        let result = sumA > sumB ? "A" : "B"
        print(result)
        winner.value = result
    }
    
    func resetGame() -> Void {
        leftOverNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Array(1...9)) as! [Int]
        shouldGenergateNext = true
        users.forEach { (user) in
            user.reset()
        }
        currentUser.value = users[firstMoveUserIndex]
        userCanRaise.value = true
        generateNextDigit()
    }
}
