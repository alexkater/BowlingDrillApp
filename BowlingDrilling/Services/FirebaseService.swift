//
//  FirebaseService.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 06/01/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import FirebaseDatabase
import ReactiveSwift

// MARK: - Firebase Database Protocol
protocol FirebaseDatabaseProtocol {

    func observeObjects<T: Decodable>(route: FirebaseRouter) -> SignalProducer<[T], Error>

    func deleteObject(route: FirebaseRouter) -> SignalProducer<Void, Error>
}

final class FirebaseService: FirebaseDatabaseProtocol {

    private lazy var database: Database = {
        let database = Database.database()
        database.isPersistenceEnabled = true
        return database
    }()

    private var databaseReference: DatabaseReference? { database.reference() }
}

// MARK: - Database Operations

extension FirebaseService {

    func query(for path: String) -> DatabaseQuery? {
        return query(for: path, keepSynced: false)
    }
    
    func observeObjects<T>(route: FirebaseRouter) -> SignalProducer<[T], Error> where T : Decodable {
        SignalProducer { [weak self] observer, _ in
            let firebaseQuery = self?.query(for: route.path)
            firebaseQuery?.observe(.value, with: { dataSnapshot in

                let objects = dataSnapshot.children.allObjects.compactMap { ($0 as? DataSnapshot)?.value as? [String: Any] }.compactMap {
                    T.decodeSafely(from: $0)
                }
                observer.send(value: objects)
                observer.sendCompleted()
            })
        }
    }

    func deleteObject(route: FirebaseRouter) -> SignalProducer<Void, Error> {
        SignalProducer { [weak self] observer, _ in
            (self?.query(for: route.path) as? DatabaseReference)?.removeValue() { (error, _) in
                if let error = error {
                    observer.send(error: error)
                } else {
                    observer.sendCompleted()
                }
            }
        }
    }

    func query(for path: String, keepSynced: Bool) -> DatabaseQuery? {
        let reference = databaseReference?.child(path)
        reference?.keepSynced(keepSynced)
        return reference
    }

    func saveObject(_ value: [String: Any], router: FirebaseRouter, completion: ((_ lastKey: String?, _ error: Error?) -> ())?) {

        let something = databaseReference?.child(router.path).childByAutoId()

        something?.setValue(value) { (error, reference) in

            completion?(reference.key, error)
        }
    }
}
