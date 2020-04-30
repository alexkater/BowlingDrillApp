//
//  DrillViewModelSpec.swift
//  BowlingDrillingTests
//
//  Created by Alejandro Arjonilla Garcia on 30/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ReactiveSwift
@testable import BowlingDrilling

final class DrillViewModelSpec: QuickSpec {

    override func spec() {
        var firebaseService: FirebaseServiceMock!
        var viewModel: DrillViewModel!
        var user: User!

        beforeEach {
            user = User.make()
            firebaseService = FirebaseServiceMock()
            viewModel = DrillViewModel(firebaseService: firebaseService, user: user)
        }

        describe("Initial values") {

            it("Values are correct") {
                expect(viewModel.title.value) == "drillscreen.navbar.title".localized
                expect(viewModel.saveButtonTitle.value) == "drillscreen.navbar.save-button.title".localized
                expect(viewModel.loading.value) == false
                expect(viewModel.error.value).to(beNil())
                expect(viewModel.leftHole.value) == HoleViewModel(with: Hole.makeLeftHole(), isFingerHole: true)
                expect(viewModel.rightHole.value) == HoleViewModel(with: Hole.makeRightHole(), isFingerHole: true)
                expect(viewModel.thumbHole.value) == HoleViewModel(with: Hole.makeThumbHole(), isFingerHole: true)
                expect(viewModel.hand.value) == .right
                expect(viewModel.name.value) == ""
                expect(viewModel.notes.value) == ""
            }
        }

        describe("Save Action") {

            context("When is successfull") {

                beforeEach {
                    firebaseService.saveObjectMock = [FirebaseRouter.user(userId: user.id): SignalProducer(value: ())]
                }

                it("Saved correctly") {
                    waitUntil { (done) in
                        viewModel.saveAction.apply(false)
                            .on(started: { expect(viewModel.loading.value) == true })
                            .on(value: { expect($0) == false })
                            .on(completed: { expect(viewModel.loading.value) == false })
                            .start()
                    }
                }
            }

            context("When failed") {

                beforeEach {
                    firebaseService.saveObjectMock = [FirebaseRouter.user(userId: user.id): SignalProducer(error: FirebaseError.undefinedError)]
                }

                it("Not saved") {
                    waitUntil { (done) in
                        viewModel.saveAction.apply(true)
                            .on(started: { expect(viewModel.loading.value) == true })
                            .on(failed: { expect($0).toNot(beNil()) })
                            .on(completed: {
                                expect(viewModel.loading.value) == false
                                expect(viewModel.error.value).toNot(beNil())
                            })
                            .start()
                    }
                }
            }
        }
    }
}
