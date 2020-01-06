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
enum FirebaseRouter {
    case users
    case user(userId: Int)

    var currentDevice: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    var path: String {
        switch self {
        case .users:
            return "/\(currentDevice)/users"
        case .user(let userId):
            return "/\(currentDevice)/users/\(userId)"
        }
    }
}

protocol FirebaseDatabaseProtocol {

    /// Function to save an object at the specified route.
    ///
    /// - Parameter value: Value that we want to save in firebase.
    /// - Parameter path: The path where the value will be saved
    /// - Parameter completion: Returns the key/id of the saved object or an error.
    func saveObject(_ value: [String: Any], router: FirebaseRouter, completion: ((_ lastKey: String?, _ error: Error?) -> ())?)

    /// Function to return a `DatabaseQuery` to start an observation and/or add more defined queries like `.queryOrderedByKey()`
    ///
    /// - Parameter path: The path of resource in Firebase
    /// - Parameter keepSynced: The data for that location will automatically be downloaded and kept in sync, even when no listeners are attached for that location.
    /// - Returns: A Firebase object to start observation
    func query(for path: String, keepSynced: Bool) -> DatabaseQuery?

    /// Generic function to retrieve a single object from Firebase.
    /// This is different from observing
    ///
    /// - Parameter databaseQuery: Query previously retrieved from `func databaseQuery(for path: String)`
    /// - Parameter completion: Completion block returning a Dictionary<String, Any> object
    func getObject(query: DatabaseQuery?, completion: ((_ json: Dictionary<String, Any>?) -> ())?)

    /// Generic function to retrieve a single object from Firebase.
    /// This is different from observing
    ///
    /// - Parameter databaseQuery: Query previously retrieved from `func databaseQuery(for path: String)`
    /// - Parameter completion: Completion block returning an object specified in the callback of the owner
    func getObject<T: Decodable>(query: DatabaseQuery?, completion: ((_ object: T?) -> ())?)

    /// Generic function to observe a Query
    ///
    /// - Parameter databaseQuery: Query previously retrieved from `func databaseQuery(for path: String)`
    /// - Parameter eventType: Type of changes required for observation
    /// - Parameter completion: Completion block returning a Dictionary<String, Any> object and the firebase data snapshot.
    /// - Returns: A Firebase object to keep track of the observer to later be able to remove observation with `func removeObserver(with handle: DatabaseHandle)`
    func observeObject(query: DatabaseQuery?, eventType: DataEventType, completion: ((_ json: Dictionary<String, Any>?, _ snapshot: DataSnapshot) -> ())?) -> DatabaseHandle?

    /// Generic function to observe a Query
    ///
    /// - Parameter databaseQuery: Query previously retrieved from `func databaseQuery(for path: String)`
    /// - Parameter eventType: Type of changes required for observation
    /// - Parameter completion: Completion block returning an object specified in the callback of the owner and the data snapshot
    /// - Returns: A Firebase object to keep track of the observer to later be able to remove observation with `func removeObserver(with handle: DatabaseHandle)`
    func observeObject<T: Decodable>(query: DatabaseQuery?, eventType: DataEventType, completion: ((_ object: T?, _ snapshot: DataSnapshot) -> ())?) -> DatabaseHandle?

    /// Generic function to observe a Query
    ///
    /// - Parameter databaseQuery: Query previously retrieved from `func databaseQuery(for path: String)`
    /// - Parameter eventType: Type of changes required for observation
    /// - Parameter completion: Completion block returning an array object specified in the callback of the owner
    /// - Returns: A Firebase object to keep track of the observer to later be able to remove observation with `func removeObserver(with handle: DatabaseHandle)`
    func observeObjects<T: Decodable>(query: DatabaseQuery?, eventType: DataEventType, completion: ((_ objects: [T]) -> ())?) -> DatabaseHandle?

    /// Function to get the server time offset in seconds.
    func getServerTimeOffset() -> SignalProducer<TimeInterval, Never>
}

extension FirebaseDatabaseProtocol {

    func query(for path: String) -> DatabaseQuery? {
        return query(for: path, keepSynced: false)
    }

    func observeObject(query: DatabaseQuery?, completion: ((_ json: Dictionary<String, Any>?, _ snapshot: DataSnapshot) -> ())?) -> DatabaseHandle? {
        return observeObject(query: query, eventType: .value, completion: completion)
    }

    func observeObject<T: Decodable>(query: DatabaseQuery?, completion: ((_ object: T?, _ snapshot: DataSnapshot) -> ())?) -> DatabaseHandle? {
        return observeObject(query: query, eventType: .value, completion: completion)
    }

    func observeObjects<T: Decodable>(query: DatabaseQuery?, completion: ((_ objects: [T]) -> ())?) -> DatabaseHandle? {
        return observeObjects(query: query, eventType: .value, completion: completion)
    }
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

    func query(for path: String, keepSynced: Bool) -> DatabaseQuery? {
        let reference = databaseReference?.child(path)
        reference?.keepSynced(keepSynced)
        return reference
    }

    func getServerTimeOffset() -> SignalProducer<TimeInterval, Never> {
        return SignalProducer<TimeInterval, Never> { [weak self] observer, _ in
            self?.databaseReference?.child(".info/serverTimeOffset").observe(.value) { snapshotData in
                guard let offset = snapshotData.value as? TimeInterval else { return observer.sendInterrupted() }
                observer.send(value: offset / 1000)
                observer.sendCompleted()
            }
        }
    }

    func saveObject(_ value: [String: Any], router: FirebaseRouter, completion: ((_ lastKey: String?, _ error: Error?) -> ())?) {

        let something = databaseReference?.child(router.path).childByAutoId()

        something?.setValue(value) { (error, reference) in

            completion?(reference.key, error)
        }
    }

    func getObject(query: DatabaseQuery?, completion: ((_ json: Dictionary<String, Any>?) -> ())?) {

        query?.observeSingleEvent(of: .value) { dataSnapshot in

            guard let value = dataSnapshot.value as? [String: Any] else { return }

            completion?(value)
        }
    }

    func getObject<T: Decodable>(query: DatabaseQuery?, completion: ((_ object: T?) -> ())?) {

        query?.observeSingleEvent(of: .value) { dataSnapshot in

            guard let value = dataSnapshot.value as? [String: Any] else { return }
            completion?(T.decodeSafely(from: value))
        }
    }

    func observeObject(query: DatabaseQuery?, eventType: DataEventType, completion: ((_ json: Dictionary<String, Any>?, _ snapshot: DataSnapshot) -> ())?) -> DatabaseHandle? {

        return query?.observe(eventType, with: { dataSnapshot in

            guard let value = dataSnapshot.value as? [String: Any] else { return }

            completion?(value, dataSnapshot)
        })
    }

    func observeObject<T: Decodable>(query: DatabaseQuery?, eventType: DataEventType, completion: ((_ object: T?, _ snapshot: DataSnapshot) -> ())?) -> DatabaseHandle? {

        return query?.observe(eventType, with: { dataSnapshot in

            guard let value = dataSnapshot.value as? [String: Any] else { return }
            let decodedObject = T.decodeSafely(from: value)
            completion?(decodedObject, dataSnapshot)
        })
    }

    func observeObjects<T: Decodable>(query: DatabaseQuery?, eventType: DataEventType, completion: ((_ objects: [T]) -> ())?) -> DatabaseHandle? {

        return query?.observe(eventType, with: { dataSnapshot in

            let objects = dataSnapshot.children.allObjects.compactMap { ($0 as? DataSnapshot)?.value as? [String: Any] }.compactMap {
                T.decodeSafely(from: $0)
            }

            completion?(objects)
        })
    }

}
extension Decodable {

/// Decodes a `Decodable` object from a Dictionary.
///
/// - Parameters:
///   - json: a dictionary
/// - Returns: Self elemetnt
    static func decodeSafely(from json: [String: Any]?) -> Self? {

        guard let json = json, let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            return nil
        }
    }
}

extension Encodable {
    /// Encode an `Encodable` object to an Array.
    ///
    /// - Parameters:
    ///   - encoder: JSON encoder to use. Default to JSONDecoder.xapo
    ///   - Returns: an Array
    func encodeSafelyArray(encoder: JSONEncoder = JSONEncoder()) -> [Any]? {
        guard let jsonData = encodeSafelyData(encoder: encoder) else { return nil }
        return (try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)) as? [Any]
    }

    /// Encode an `Encodable` object to String.
    ///
    /// - Parameters:
    ///   - encoder: JSON encoder to use. Default to JSONDecoder.xapo
    ///   - Returns: a String
    func encodeSafelyString(encoder: JSONEncoder = JSONEncoder()) -> String? {
        guard let data = encodeSafelyData(encoder: encoder) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Encode an `Encodable` object to Data.
    ///
    /// - Parameters:
    ///   - encoder: JSON encoder to use. Default to JSONDecoder.xapo
    ///   - Returns: encoded data
    func encodeSafelyData(encoder: JSONEncoder = JSONEncoder()) -> Data? {
        do {
            return try encoder.encode(self)
        } catch {
            print("[ENCODER] Could not encode \(Self.self). Error: \(error)")
            return nil
        }
    }

    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)

            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
              return nil
            }
            return dictionary
        } catch {
            return nil
        }
    }
}
