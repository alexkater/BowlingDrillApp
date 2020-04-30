//
//  PitchModel.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

extension Date {

    var drillingDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}

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
                    name: "Change name \(Date().drillingDescription)",
                    notes: "",
                    leftHole: .makeLeftHole(),
                    rightHole: .makeRightHole(),
                    thumbHole: .makeThumbHole(),
                    hand: .right)
    }
}

// MARK: - Hole
struct Hole: Codable, Equatable {
    var forwardPitch, backwardPitch, leftPitch, rightPitch: String
    let holeSize, cutSpan, span: String

    static func make() -> Hole {
        return Hole(forwardPitch: "0", backwardPitch: "0", leftPitch: "0", rightPitch: "0", holeSize: "0", cutSpan: "0", span: "0")
    }

    static func makeLeftHole() -> Hole {
        return Hole(forwardPitch: "3/8", backwardPitch: "0", leftPitch: "3/8", rightPitch: "0", holeSize: "0", cutSpan: "0", span: "0")
    }

    static func makeRightHole() -> Hole {
        return Hole(forwardPitch: "3/8", backwardPitch: "0", leftPitch: "0", rightPitch: "3/8", holeSize: "0", cutSpan: "0", span: "0")
    }

    static func makeThumbHole() -> Hole {
        return Hole(forwardPitch: "1/8", backwardPitch: "0", leftPitch: "0", rightPitch: "0", holeSize: "0", cutSpan: "0", span: "0")
    }
}
