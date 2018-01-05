//
//  StartViewModel.swift
//  DigitsGamble
//
//  Created by Mia on 04/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import Foundation

struct StartViewModel {
    
    var selectedUserIndex: Int?
    
    var users: [User] = GameEngine.shared.generateUsers()
    
}
