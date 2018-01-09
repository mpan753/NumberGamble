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
    
    let currentDigit: Variable<Int> = Variable(0)
    
    let winner: Variable<String?> = Variable(nil)
    
    let userCanRaise: Variable<Bool> = Variable(true)
    
    var firstMoveUserIndex: Int
    
    var maxOfferPerRound: Int {
        let maxUser = users.max { (A, B) -> Bool in
            A.offer.value.price < B.offer.value.price
            }
        
        return (maxUser?.offer.value.price)!
    }
    
    init(startViewModel model: StartViewModel) {
        self.users = model.users
        self.firstMoveUserIndex = model.selectedUserIndex!
        self.currentUser.value = self.users[model.selectedUserIndex!]
        self.leftOverNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Array(1...9)) as! [Int]
        self.shouldGenergateNext = true
    }
    
    private func generateNextDigit() {
        _ = nextDigit()
    }
    
    func startNewRound() {
        shouldGenergateNext = true
        generateNextDigit()
        users.forEach { (user) in
            user.clearForNextRound()
        }
        currentUser.value = users[firstMoveUserIndex]
    }
    
    private func nextDigit() -> Int {
        if !shouldGenergateNext {
            return currentDigit.value
        }
        if leftOverNumbers.count == 0 {
            let user = users.max(by: { (user1, user2) -> Bool in
                user1.digitsSum < user2.digitsSum
            })
            
            winner.value = user?.name
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
        if let fund = currentUser.value?.availableFund.value {
            userCanRaise.value = fund > 0 && fund > maxOfferPerRound
        }
    }
    
    func shouldMakeAJudge() -> Bool {
        let allDidOffer = users.reduce(true) { (offer, user) -> Bool in
            offer && user.didOffer
        }
        guard allDidOffer else {
            return false
        }
        
        return (users.count - numOfPassedUsers) <= 1
    }
    
    var digitBuyer: User? {
        if numOfPassedUsers == 1 {
            return users.filter({ (user) -> Bool in
                switch user.offer.value {
                case .price(_):
                    return true
                default:
                    return false
                }
            }).first
        }
        return nil
    }
    
    var numOfPassedUsers: Int {
        return users.filter { (user) -> Bool in
            switch user.offer.value {
            case .pass:
                return true
            default:
                return false
            }
            }.count
    }
    
    var allUsersDidPassed: Bool {
        return numOfPassedUsers == users.count
    }
    
    func resetGame() -> Void {
        leftOverNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Array(1...9)) as! [Int]
        shouldGenergateNext = true
        users.forEach { (user) in
            user.reset()
        }
        currentUser.value = users[firstMoveUserIndex]
        userCanRaise.value = true
        startNewRound()
    }
    
    
}
