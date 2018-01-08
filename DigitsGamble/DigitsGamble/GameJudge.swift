//
//  GameJudge.swift
//  DigitsGamble
//
//  Created by Mia on 08/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation

class GameJudge {
    
    static let shared = GameJudge()
    
    func judge(from users: [User]) -> User {
        let user = users.max { (user1, user2) -> Bool in
            return user1.offeredPrice.value > user2.offeredPrice.value
        }
        
        return user!
    }
    
    var currentOffer: Int = 0
    
}
