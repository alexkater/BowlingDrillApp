//
//  DIService.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

import Foundation

var stateManager = StateManager()

protocol StateManagerProtocol {

    var firebaseDatabase: FirebaseDatabaseProtocol { get }

    /// Starts all services which need initial configuration, like Realm, Firebase...
    func start()
}

/// DIP State Manager, from here we will retrieve every dependency needed
class StateManager: StateManagerProtocol {
    typealias DatabaseCreator = () -> FirebaseDatabaseProtocol

    let firebaseDatabase: FirebaseDatabaseProtocol

    init(
        databaseCreator: DatabaseCreator = StateManager.defaultDatabaseServiceCreator()
        ) {
        firebaseDatabase = databaseCreator()
    }

    func start() {
    }
}

private typealias ClassFunctions = StateManager
extension ClassFunctions {

    class func defaultDatabaseServiceCreator() -> DatabaseCreator {
        return {
            FirebaseService()
        }
    }
}

