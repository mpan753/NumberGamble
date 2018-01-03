//
//  GameEngine.swift
//  DigitsGamble
//
//  Created by Mia on 03/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation

class GameEngine {
    
    static let shared = GameEngine()
    
    var model: GameModel?
    
    func start(with user: User) {
        print("[\(#line)] : \(type(of: self)).\(#function)")
        model = GameModel(initialUser: user)
        print(GameEngine.shared.model?.currentUser)
    }
    
}
