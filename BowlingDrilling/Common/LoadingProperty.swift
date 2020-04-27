//
//  LoadingProperty.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

/// Mutable LoadingTrackerProperty, it tracks the request and maps it to a Bool to indicate
/// if the view controller should shows a spinner.
final class LoadingTrackerProperty: PropertyProtocol {

    var producer: SignalProducer<Bool, Never> { internalProperty.producer.skipRepeats() }
    var signal: Signal<Bool, Never> { internalProperty.signal.skipRepeats() }
    var value: Bool { internalProperty.value }
    var loadingProperty: LoadingProperty { LoadingProperty(tracker: self) }

    private let internalProperty = MutableProperty(false)
    private var loadingCount = 0
    private var isLoadingPause = false

    /// This function should be called when the request starts.
    func startLoad() {
        guard !isLoadingPause else { return }

        loadingCount += 1
        internalProperty.value = true
    }

    /// This function should be called when the request finishes.
    func finishLoad() {
        guard !isLoadingPause else { return }

        if loadingCount > 0 {
            loadingCount -= 1
            internalProperty.value = loadingCount != 0
        }
    }

    func startTracking() {
        isLoadingPause = false
    }

    func pauseTracking() {
        isLoadingPause = true
    }
}

/// Immutable LoadingProperty, it forwards all event from the given LoadingTrackerProperty.
final class LoadingProperty: PropertyProtocol {

    var producer: SignalProducer<Bool, Never> { tracker.producer.skipRepeats() }
    var signal: Signal<Bool, Never> { tracker.signal.skipRepeats() }
    var value: Bool { tracker.value }

    private let tracker: LoadingTrackerProperty

    init(tracker: LoadingTrackerProperty) {
        self.tracker = tracker
    }
}

// MARK: - Helpers
extension SignalProducer {

    /// Tracks this producer's work on the specified `LoadingTrackerProperty` property.
    ///
    /// - parameters:
    ///   - loadingTracker: The `LoadingTrackerProperty` to use for tracking this producer.
    ///   - waitForTerminatingEvent: Indicates if loading should be set to `false` only when a terminating event is received,
    ///                              or as soon as the first event (including values), is received.
    func track(on loadingTracker: LoadingTrackerProperty, waitForTerminatingEvent: Bool = false) -> SignalProducer<Value, Error> {
        return on(starting: { [weak loadingTracker] in loadingTracker?.startLoad() })
            .on(event: { [weak loadingTracker] event in
                if event.isTerminating || !waitForTerminatingEvent {
                    loadingTracker?.finishLoad()
                }
            }
        ).on(completed: { [weak loadingTracker] in
            loadingTracker?.finishLoad()
        })
    }

}

extension Action {

    @discardableResult
    func track(on loadingTracker: LoadingTrackerProperty) -> Action<Input, Output, Error> {
        isExecuting.producer.on(value: { [weak loadingTracker] isExecuting in
            isExecuting ? loadingTracker?.startLoad() : loadingTracker?.finishLoad()
        }).start()

        return self
    }

}
