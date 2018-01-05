//
//  GameEngine.swift
//  DigitsGamble
//
//  Created by Mia on 03/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GameEngine {
    
    static let shared = GameEngine()
    
    func start() {

    }
    
    func generateUsers() -> [User] {
        let userA = User(name: "A")
        let userB = User(name: "B")
        return [
            userA,
            userB
        ]
    }
    
}
