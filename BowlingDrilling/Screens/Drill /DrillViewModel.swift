//
//  DrillViewModel.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 30/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol DrillViewModelProtocol {
    var title: Property<String?> { get }
    var saveButtonTitle: Property<String?> { get }
    var loading: LoadingProperty { get }
    var error: Property<String?> { get }
    var leftHole: MutableProperty<HoleViewModel?> { get }
    var rightHole: MutableProperty<HoleViewModel?> { get }
    var thumbHole: MutableProperty<HoleViewModel?> { get }

    var hand: MutableProperty<User.Hand> { get }
    var name: MutableProperty<String?> { get }
    var notes: MutableProperty<String?> { get }

    var saveAction: Action<Bool, Bool, Error> { get }
}

final class DrillViewModel: DrillViewModelProtocol {

    var leftHole = MutableProperty<HoleViewModel?>(nil)
    var rightHole = MutableProperty<HoleViewModel?>(nil)
    var thumbHole = MutableProperty<HoleViewModel?>(nil)
    var hand = MutableProperty<User.Hand>(.right)
    var name = MutableProperty<String?>(nil)
    var notes = MutableProperty<String?>(nil)
    lazy var saveAction = createSaveAction()

    private var user: Property<User>

    var title = Property<String?>(value: "drillscreen.navbar.title".localized)
    var saveButtonTitle = Property<String?>(value: "drillscreen.navbar.save-button.title".localized)

    /// Loading and tracking
    lazy var loading = LoadingProperty(tracker: loadingTracker)
    private let loadingTracker = LoadingTrackerProperty()
    lazy var error = Property(capturing: mutableError)
    private let mutableError = MutableProperty<String?>(nil)

    private let firebaseService: FirebaseDatabaseProtocol

    init(firebaseService: FirebaseDatabaseProtocol = stateManager.firebaseDatabase,
         user: User) {
        self.firebaseService = firebaseService
        self.user = Property(value: user)

        setupBindings()
    }

    func createSaveAction() -> Action<Bool, Bool, Error> {
        Action { [weak self] haveToDismiss in
            guard let strongSelf = self,
                let user = self?.getUpdatedUser() else { return .empty }

            return strongSelf.firebaseService
                .saveObject(route: .user(userId: user.id), object: user)
                .delay(0.7, on: QueueScheduler.main)
                .track(on: strongSelf.loadingTracker)
                .on(failed: { [weak self] error in
                    self?.mutableError.value = error.localizedDescription
                })
                .map { _ in return haveToDismiss }
        }
    }
}

private extension DrillViewModel {

    func setupBindings() {

        user.producer.startWithValues { [weak self] (user) in
            self?.leftHole.value = HoleViewModel(with: user.leftHole, isFingerHole: true)
            self?.rightHole.value = HoleViewModel(with: user.rightHole, isFingerHole: true)
            self?.thumbHole.value = HoleViewModel(with: user.thumbHole, isFingerHole: false)
            self?.hand.value = user.hand
            self?.name.value = user.name
            self?.notes.value = user.notes
        }
    }

    func getUpdatedUser() -> User? {
        var savedUser = user.value
        savedUser.leftHole = leftHole.value!.hole
        savedUser.rightHole = rightHole.value!.hole
        savedUser.thumbHole = thumbHole.value!.hole
        savedUser.hand = hand.value
        savedUser.name = name.value ?? "Change name \(Date().drillingDescription)"
        savedUser.notes = notes.value ?? ""
        return savedUser
    }
}
