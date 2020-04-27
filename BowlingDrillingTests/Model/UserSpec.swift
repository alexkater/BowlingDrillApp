//
//  UserSpec.swift
//  BowlingDrillingTests
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import BowlingDrilling

final class UserSpec: QuickSpec {

    override func spec() {

        var user: User?


        fdescribe("Parsing") {

            beforeEach {
                user = User.decodeSafely(from: self.jsonString)
            }

            it("has id") {
                expect(user?.id) == "1"
            }

            it("has name") {
                expect(user?.name) == "Alejandro"
            }

            it("has leftHole") {
                expect(user?.leftHole) == Hole.makeLeftHole()
            }

            it("has rightHole") {
                expect(user?.rightHole) == Hole.makeRightHole()
            }

            it("has thumbHole") {
                expect(user?.thumbHole) == Hole.makeThumbHole()
            }

            it("has hand") {
                expect(user?.hand) == .right
            }

            it("has notes") {
                expect(user?.notes) == "Nothing yet"
            }
        }
    }

    let jsonString = """
       {
            "id": "1",
            "name" : "Alejandro",
            "leftHole": {
                "forwardPitch": "3/8",
                "backwardPitch": "0",
                "leftPitch": "3/8",
                "rightPitch": "0",
                "holeSize": "0",
                "cutSpan": "0",
                "span": "0"
            },
            "rightHole": {
                "forwardPitch": "3/8",
                "backwardPitch": "0",
                "leftPitch": "0",
                "rightPitch": "3/8",
                "holeSize": "0",
                "cutSpan": "0",
                "span": "0"
            },
            "thumbHole": {
                "forwardPitch": "1/8",
                "backwardPitch": "0",
                "leftPitch": "0",
                "rightPitch": "0",
                "holeSize": "0",
                "cutSpan": "0",
                "span": "0"
            },
            "hand": "R",
            "notes": "Nothing yet"
        }
    """
}
