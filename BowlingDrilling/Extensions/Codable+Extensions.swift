//
//  Codable+Extensions.swift
//  BowlingDrilling
//
//  Created by Alejandro Arjonilla Garcia on 27/04/2020.
//  Copyright © 2020 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

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

    static func decodeSafely(from string: String?,
                             stringEncoding: String.Encoding = .utf8) -> Self? {

        guard let data = string?.data(using: stringEncoding) else { return nil }

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

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
