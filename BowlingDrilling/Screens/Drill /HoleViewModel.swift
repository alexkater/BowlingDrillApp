//
//  HoleViewModel.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 30/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

struct HoleViewModel {
    let forwardPitch = MutableProperty<String>("0")
    let backwardPitch = MutableProperty<String>("0")
    let leftPitch = MutableProperty<String>("0")
    let rightPitch = MutableProperty<String>("0")
    let holeSize = MutableProperty<String>("0")
    let cutSpan = MutableProperty<String>("0")
    let span = MutableProperty<String>("0")

    let isFingerHole: Bool

    init(with hole: Hole, isFingerHole: Bool) {
        self.isFingerHole = isFingerHole
        self.forwardPitch.value = hole.forwardPitch
        self.backwardPitch.value = hole.backwardPitch
        self.leftPitch.value = hole.leftPitch
        self.rightPitch.value = hole.rightPitch
        self.holeSize.value = hole.holeSize
        self.cutSpan.value = hole.cutSpan
        self.span.value = hole.span
    }

    var hole: Hole {
        return Hole(forwardPitch: forwardPitch.value, backwardPitch: backwardPitch.value,
                    leftPitch: leftPitch.value, rightPitch: rightPitch.value,
                    holeSize: holeSize.value, cutSpan: cutSpan.value, span: span.value)
    }
}

extension HoleViewModel: Equatable {


    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.forwardPitch.value == rhs.forwardPitch.value &&
        lhs.backwardPitch.value == rhs.backwardPitch.value &&
        lhs.leftPitch.value == rhs.leftPitch.value &&
        lhs.rightPitch.value == rhs.rightPitch.value &&
        lhs.holeSize.value == rhs.holeSize.value &&
        lhs.cutSpan.value == rhs.cutSpan.value &&
        lhs.span.value == rhs.span.value
    }
}
