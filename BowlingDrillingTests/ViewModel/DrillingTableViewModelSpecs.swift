//
//  DrillingTableViewModel.swift
//  BowlingDrillingTests
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ReactiveSwift
@testable import BowlingDrilling

final class DrillingTableViewModelSpec: QuickSpec {

    override func spec() {
        var firebaseService: FirebaseServiceMock!
        var viewModel: DrillingTableViewModelProtocol!

        func setupViewModel() {
            viewModel = DrillingTableViewModel(firebaseService: firebaseService)
        }

        beforeEach {
            firebaseService = FirebaseServiceMock()
        }

        describe("Initial state") {

            beforeEach {
                setupViewModel()
            }

            context("Static values") {

                it("Buttons texts are correct") {
                    expect(viewModel.addDrillButtonTitle.value) == "drillscreen.gif.button.title".localized
                    expect(viewModel.changeBackgroundButtonTitle.value) == "drillscreen.drill.button.title".localized
                }
            }
        }

        describe("Fetch data") {

            context("When fetch goes well") {

                beforeEach {
                    let producer: SignalProducer<[Any], Error> = SignalProducer(value: [UserMock.make()])
                    firebaseService.observeObjectsMock = [FirebaseRouter.users: producer]
                    setupViewModel()
                }

                it("user load as expected") {
                    expect(viewModel.cellViewModels.value).toEventuallyNot(beEmpty(), timeout: 100)
                }
            }

            context("When fetch goes well") {

                beforeEach {
                    let producer: SignalProducer<[Any], Error> = SignalProducer(error: FirebaseError.nodataFound)
                    firebaseService.observeObjectsMock = [FirebaseRouter.users: producer]
                    setupViewModel()
                }

                it("user load as expected") {
                    expect(viewModel.cellViewModels.value).toEventually(beEmpty())
                    expect(viewModel.error.value).toEventually(equal(FirebaseError.nodataFound.localizedDescription))
                }
            }
        }

        describe("Delete Drill") {
            beforeEach {
                setupViewModel()
            }

            context("When user delete a drill") {

                context("And went well") {

                    beforeEach {
                        var producer: SignalProducer<[Any], Error> = SignalProducer(value: [UserMock.make()])
                        firebaseService.observeObjectsMock = [FirebaseRouter.users: producer]
                        firebaseService.deleteObjectMock = [FirebaseRouter.user(userId: "0"): SignalProducer(value: ())]
                        viewModel.deleteUser(with: 0)
                        producer = SignalProducer(value: [])
                        firebaseService.observeObjectsMock = [FirebaseRouter.users: producer]
                    }

                    it("Success") {
                        expect(viewModel.cellViewModels.value).toEventually(beEmpty())
                    }
                }

                context("And fail") {

                    beforeEach {
                        let producer: SignalProducer<[Any], Error> = SignalProducer(value: [UserMock.make()])
                        firebaseService.observeObjectsMock = [FirebaseRouter.users: producer]
                        setupViewModel()
                        firebaseService.deleteObjectMock = [FirebaseRouter.user(userId: "1"): SignalProducer(error: FirebaseError.nodataFound)]
                        viewModel.deleteUser(with: 0)
                    }

                    it("Show error and have same length") {
                        expect(viewModel.error.value).toEventually(equal(FirebaseError.nodataFound.localizedDescription))
                    }
                }
            }
        }
    }
}
