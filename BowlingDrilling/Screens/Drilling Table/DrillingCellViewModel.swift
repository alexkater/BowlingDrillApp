//
//  DrillingCellViewModel.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

struct DrillingCellViewModel {
    let name: String
    let hand: String
    let user: User

    init(user: User) {
        self.user = user
        self.name = user.name
        self.hand = user.hand.rawValue
    }
}
