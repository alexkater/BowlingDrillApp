//
//  UserMock.swift
//  BowlingDrillingTests
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

@testable import BowlingDrilling

struct UserMock {
    
    static func make(id: String = "1",
                     name: String = "Peter",
                     notes: String = "No notes",
                     leftHole: Hole = .makeLeftHole(),
                     rightHole: Hole = .makeRightHole(),
                     thumbHole: Hole = .makeThumbHole(),
                     hand: User.Hand = .right) -> User {
        return User(id: id,
                    name: name,
                    notes: notes,
                    leftHole: leftHole,
                    rightHole: rightHole,
                    thumbHole: thumbHole,
                    hand: hand)
    }
}
