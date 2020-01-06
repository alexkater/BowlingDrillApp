//
//  PitchModel.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {

    enum Hand: String, Codable {
        case left = "L"
        case right = "R"

        var isRightHanded: Bool {
            return self == .right
        }
    }

    var id, name, notes: String
    var leftHole, rightHole, thumbHole: Hole
    var hand: Hand

    static func make() -> User {
        return User(id: UUID().uuidString,
                    name: "No Name yet! \(Date().description)",
                    notes: "",
                    leftHole: .makeLeftHole(),
                    rightHole: .makeRightHole(),
                    thumbHole: .makeThumbHole(),
                    hand: .right)
    }
}

// MARK: - Hole
struct Hole: Codable {
    let forwardPitch, backwardPitch, leftPitch, rightPitch: String
    let holeSize, cutSpan, span: String

    static func make() -> Hole {
        return Hole(forwardPitch: "", backwardPitch: "", leftPitch: "", rightPitch: "", holeSize: "", cutSpan: "", span: "")
    }

    static func makeLeftHole() -> Hole {
        return Hole(forwardPitch: "3/8", backwardPitch: "", leftPitch: "3/8", rightPitch: "", holeSize: "", cutSpan: "", span: "")
    }

    static func makeRightHole() -> Hole {
        return Hole(forwardPitch: "3/8", backwardPitch: "", leftPitch: "", rightPitch: "3/8", holeSize: "", cutSpan: "", span: "")
    }

    static func makeThumbHole() -> Hole {
        return Hole(forwardPitch: "1/8", backwardPitch: "", leftPitch: "", rightPitch: "", holeSize: "", cutSpan: "", span: "")
    }
}
