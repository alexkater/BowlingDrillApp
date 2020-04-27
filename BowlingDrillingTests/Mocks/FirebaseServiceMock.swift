//
//  FirebaseServiceMock.swift
//  BowlingDrillingTests
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import ReactiveSwift

@testable import BowlingDrilling

final class FirebaseServiceMock: FirebaseDatabaseProtocol {

    var observeObjectsMock: [FirebaseRouter: SignalProducer<[Any], Error>] = [:]
    var deleteObjectMock: [FirebaseRouter: SignalProducer<Void, Error>] = [:]

    func observeObjects<T: Decodable>(route query: FirebaseRouter) -> SignalProducer<[T], Error> {
        let mapped = observeObjectsMock[query]?.map { $0 as! [T] }
        return mapped ?? .empty
    }

    func deleteObject(route query: FirebaseRouter) -> SignalProducer<Void, Error> {
        return deleteObjectMock[query] ?? .empty
    }
}

enum FirebaseError: Error {
    case nodataFound
}
