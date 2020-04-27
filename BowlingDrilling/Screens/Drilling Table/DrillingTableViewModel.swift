//
//  DrillingTableViewModel.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol DrillingTableViewModelProtocol {
    var addDrillButtonTitle: Property<String> { get }
    var changeBackgroundButtonTitle: Property<String> { get }
    var cellViewModels: Property<[DrillingCellViewModel]> { get }
    var loading: LoadingProperty { get }
    var error: Property<String?> { get }

    func deleteUser(with index: Int)
}

final class DrillingTableViewModel: DrillingTableViewModelProtocol {
    
    lazy var cellViewModels = Property(capturing: mutableCellsViewModels)
    lazy var loading = LoadingProperty(tracker: loadingTracker)
    lazy var error = Property(capturing: mutableError)

    var addDrillButtonTitle = Property(value: "drillscreen.gif.button.title".localized)
    var changeBackgroundButtonTitle = Property(value: "drillscreen.drill.button.title".localized)

    private let mutableError = MutableProperty<String?>(nil)
    private let loadingTracker = LoadingTrackerProperty()
    private let mutableCellsViewModels = MutableProperty<[DrillingCellViewModel]>([])
    private let firebaseService: FirebaseDatabaseProtocol

    init(firebaseService: FirebaseDatabaseProtocol = stateManager.firebaseDatabase) {
        self.firebaseService = firebaseService

        setupBindings()
    }

    func deleteUser(with index: Int) {
        guard let user = cellViewModels.value[safe: index]?.user else {
            // TODO: @aarjonilla track error
            return
        }

        firebaseService
            .deleteObject(route: FirebaseRouter.user(userId: user.id))
            .track(on: loadingTracker)
            .on(failed: { [weak self] error in
                self?.mutableError.value = error.localizedDescription
            })
            .start()
    }
}

private extension DrillingTableViewModel {


    func setupBindings() {

        firebaseService.observeObjects(route: .users)
            .track(on: loadingTracker)
            .on(value: { [weak self] (users: [User]) in
                self?.mutableCellsViewModels.value = users.map { DrillingCellViewModel(user: $0) }
            })
            .on(failed: { [weak self] error in
                self?.mutableError.value = error.localizedDescription
            })
            .start()
    }
}
